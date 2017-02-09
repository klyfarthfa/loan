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
    
    shared_examples 'a nonnegative numerical field' do |parameter|
      context 'is not a number' do
        before(:each) do
          params.merge!({ parameter => 'a black cat' })
        end
        it_should_behave_like 'an invalid application'
      end
      context 'is less than zero' do
        before(:each) do
          params.merge!({ parameter => -5046 })
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
      it_should_behave_like 'a nonnegative numerical field', :loan_amount
    end

    context 'prop value' do
      let!(:params) {
        {
          loan_amount: 50000,
          ssn: "555158423"
        }
      }
      it_should_behave_like 'a required presence', :prop_value
      it_should_behave_like 'a nonnegative numerical field', :prop_value
    end
  
    context 'ssn' do
      let!(:params) {
        {
          loan_amount: 50000,
          prop_value: 5000
        }
      }
      it_should_behave_like 'a required presence', :ssn
      context 'is too long' do
        before(:each) do
          params.merge!({ssn: "5521837214219573148"})
        end
        it_should_behave_like 'an invalid application'
      end
      context 'is an invalid ssn number' do
        before(:each) do
          params.merge!({ssn: "000000000"})
        end
        it_should_behave_like 'an invalid application'
      end
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

  # According to what I found on the internet, valid SSNs are
  # a sequence of 9 numbers, divided into three groups [3,2,4].
  # Any of these three groups can't be all zeroes, and the first three
  # numbers also cannot be 900-999 or 666. It also can't match one of the
  # two numbers that are considered fake.
  describe '#ssn_is_valid' do
    let!(:params) {
      {
        loan_amount: 1,
        prop_value: 1
      }
    }
    let(:loan) {
      LoanApplication.new(params)
    }
    subject { loan.ssn_is_valid }

    context "ssn is a fake number" do
      before(:each) do
        params.merge!({ssn: "078051120"})
      end
      it 'should add an error' do
         expect { subject }.to change { loan.errors.count } 
      end
      it 'should give fake ssn message' do
        subject
        expect(loan.errors[:ssn]).to include("is a fake ssn")
      end
    end

    shared_examples 'a invalid ssn' do
      it 'should add an error' do
        expect { subject }.to change { loan.errors.count } 
      end
      it 'should give invalid ssn message' do
        subject
        expect(loan.errors[:ssn]).to include("is invalid")
      end
    end

    context "ssn starts with 000" do
      before(:each) do
        params.merge!({ssn: "000051120"})
      end
      it_should_behave_like 'a invalid ssn'
    end

    context "ssn starts with 666" do
      before(:each) do
        params.merge!({ssn: "666051120"})
      end
      it_should_behave_like 'a invalid ssn'
    end

    context "ssn starts with a number between 900 and 999" do
      before(:each) do
        params.merge!({ssn: "978051120"})
      end
      it_should_behave_like 'a invalid ssn'
    end

    context "ssn middle is 00" do
      before(:each) do
        params.merge!({ssn: "554001120"})
      end
      it_should_behave_like 'a invalid ssn'
    end

    context "ssn last four is 0000" do
      before(:each) do
        params.merge!({ssn: "554570000"})
      end
      it_should_behave_like 'a invalid ssn'
    end
  end
end