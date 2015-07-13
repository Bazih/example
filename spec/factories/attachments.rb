FactoryGirl.define do
  factory :attachment do
    file ActionDispatch::Http::UploadedFile.new(:tempfile => File.new("#{Rails.root}/public/robots.txt"), :filename => "robots.txt")
  end

end
