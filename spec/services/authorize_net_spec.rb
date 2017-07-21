require 'rails_helper'

RSpec.describe AuthorizeNet do
  describe '#capture_authorized_amount' do
    let(:customer) { create :customer }
    let(:response) { double :response }
    let(:result1) do
      { 'transactionResponse' =>
        { 'responseCode'   => '3',
          'authCode'       => '',
          'avsResultCode'  => 'P',
          'cvvResultCode'  => '',
          'cavvResultCode' => '',
          'transId'        => '0',
          'refTransID'     => '60021018927',
          'transHash'      => '8CEF62CD685C8D71C412FCE6CDBCCCA6',
          'testRequest'    => '0',
          'accountNumber'  => '',
          'accountType'    => 'Visa',
          'errors' => [{ 'errorCode' => '47', 'errorText' => 'The amount requested for settlement cannot be greater' \
                         'than the original amount authorized.' }],
          'transHashSha2' => '' },
        'messages' => { 'resultCode' => 'Error',
                        'message' => [{ 'code' => 'E00027', 'text' => 'The transaction was unsuccessful.' }] } }
    end

    let(:result2) do
      { 'transactionResponse' =>
        { 'responseCode'   => '1',
          'authCode'       => 'UK3ZSY',
          'avsResultCode'  => 'P',
          'cvvResultCode'  => '',
          'cavvResultCode' => '',
          'transId'        => '60021022229',
          'refTransID'     => '60021022229',
          'transHash'      => '9820A6E55FCF14A8F87D967EE7F71EE9',
          'testRequest'    => '0',
          'accountNumber'  => 'XXXX0015',
          'accountType'    => 'MasterCard',
          'messages'       => [{ 'code' => '1', 'description' => 'This transaction has been approved.' }],
          'transHashSha2' => '' },
        'messages' => { 'resultCode' => 'Ok', 'message' => [{ 'code' => 'I00001', 'text' => 'Successful.' }] } }
    end

    subject { described_class.new(customer) }

    before do
      allow(described_class).to receive(:post) { response }
      allow(response).to receive_message_chain(:body, :delete) { response }
    end

    context 'invalid amount of money' do
      before { allow(JSON).to receive(:parse).with(response) { result1 } }

      specify do
        expect do
          subject.capture_authorized_amount(transaction_id: 600_210_189_27, amount: 105.95, save_credit_card: true)
        end.to raise_error(result1['messages']['message'].to_sentence)
      end
    end

    context 'successfull' do
      before { allow(JSON).to receive(:parse).with(response) { result2 } }

      specify do
        subject.capture_authorized_amount(transaction_id: 600_210_222_29, amount: 15.05, save_credit_card: true)

        CreditCard.last do |credit_card|
          expect(credit_card.auth_code).to eq 'UK3ZSY'
          expect(credit_card.trans_id).to eq '60021022229'
          expect(credit_card.account_number).to eq 'XXXX0015'
          expect(credit_card.account_type).to eq 'MasterCard'
        end
      end
    end

    context 'fail' do
      before { allow(JSON).to receive(:parse).with(response) { result2 } }

      specify do
        result = subject.capture_authorized_amount(transaction_id: 600_210_222_29, amount: 15.05,
                                                   save_credit_card: true)
        expect { result }.to_not change(CreditCard, :count)
      end
    end
  end
end
