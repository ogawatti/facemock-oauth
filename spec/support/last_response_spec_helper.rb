module RackMiddlewareSpecHelper
  shared_context "200 OK", assert: :RequestSuccess do
    it 'should return 200 OK' do
      get @path
      expect(last_response.status).to eq 200
      expect(last_response.body).not_to be_nil
      expect(last_response.header).not_to be_empty
    end
  end
end
