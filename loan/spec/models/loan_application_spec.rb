require 'rails_helper'

RSpec.describe LoanApplication, type: :model do
  context 'creating a new loan application' do
    subject { LoanApplication.new(params) }
    context 'everything is valid' do
      let(:params) {
        {
          loan_amount: 50000,
          prop_value: 5000,
          ssn: "555158423"
        }
      }
      it 'should not explode' do
        expect(subject).to be_truthy
      end
      it 'should be savable' do
        expect { subject.save }.to change { LoanApplication.count }.by(1)
        expect(subject.id).to be_present
      end
    end

    shared_examples 'an invalid application' do
      it { is_expected.to_not be_valid }
      it 'should not be savable' do
        expect { subject.save }.to_not change { LoanApplication.count}
        expect { subject.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(subject).to be_a_new(LoanApplication)
      end
    end

    shared_examples 'a required presence' do |parameter|
      context 'is blank' do
        before(:each) do
          { parameter => '' }
          params.merge!({ parameter => '' })
        end
        it_should_behave_like 'an invalid application'
      end
      context 'is not present' do
        it_should_behave_like 'an invalid application'
      end
    end
    
    shared_examples 'a numerical field' do |parameter|
      context 'is not a number' do
        before(:each) do
          params.merge!({ parameter => 'a black cat' })
        end
        it_should_behave_like 'an invalid application'
      end
    end

    context 'loan amount' do
      let!(:params) {
          {
            prop_value: 5000,
            ssn: "555158423"
          }
        }

      it_should_behave_like 'a required presence', :loan_amount
      it_should_behave_like 'a numerical field', :loan_amount
    end

    context 'prop value' do
      let!(:params) {
        {
          loan_amount: 50000,
          ssn: "555158423"
        }
      }
      it_should_behave_like 'a required presence', :prop_value
      it_should_behave_like 'a numerical field', :prop_value
    end
  
    context 'ssn' do
      let!(:params) {
        {
          loan_amount: 50000,
          prop_value: 5000
        }
      }
      it_should_behave_like 'a required presence', :ssn
    end
  end
  describe '#status' do
    let(:params) {
      {
        loan_amount: loan,
        prop_value: value,
        ssn: "555158423"
      }
    }
    
    context 'on a new object' do
      subject { LoanApplication.new(params) }
      context 'that is valid' do
        let(:loan) { 5000 }
        let(:value) { 5000 }
        it 'should be set during the before_save hook' do
          expect(subject.status).to_not be_present
          subject.save
          expect(subject.status).to be_present
        end
      end

      context 'that is invalid' do
        let(:loan) { 'a black cat' }
        let(:value) { 'a white cat' }
        it 'should not set the status' do
          subject.save
          expect(subject.status).to_not be_present
        end
      end
    end

    context 'with a ltv ratio exceeding 40%' do
      subject { LoanApplication.create!(params).status }
      let(:loan) { 50 }
      let(:value) { 1 }
      it { is_expected.to eq("rejected") }
    end

    context 'with a ltv ratio less or equal to 40%' do
      subject { LoanApplication.create!(params).status }
      let(:loan) { 40 }
      let(:value) { 100 }
      it { is_expected.to eq("accepted") }
    end
  end
end