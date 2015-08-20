shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(url)
      expect(response).to have_http_status :unauthorized
    end

    it 'returns 401 status if access_token is not valid' do
      do_request(url, access_token: '1234')
      expect(response).to have_http_status :unauthorized
    end
  end
end