RSpec.describe Jpegsan do
  it "has a version number" do
    expect(Jpegsan::VERSION).not_to be nil
  end

  it 'opens a JPEG file' do
    file = open("#{__dir__}/sample.jpg")
    jpeg = Jpegsan::Jpeg.new(file)
    expect(jpeg.data[0]).to be_a(Jpegsan::Jpeg::JpegMarker)
  end
end
