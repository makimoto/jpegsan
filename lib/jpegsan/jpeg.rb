module Jpegsan
class Jpeg
  attr_accessor :data

  JpegMarker = Struct.new(:code_suffix, :symbol, :description, :data_sequence) do
    def code
      "\xff#{code_suffix}".b
    end

    def to_bytes
      "#{code}#{data_sequence}".b
    end

    def sequence_in_hex
      if data_sequence.nil?
        return nil
      end
      data_sequence.unpack('H*').first.chars.each_slice(2).map(&:join).join(' ')
    end
  end

  # Table B.1 in https://www.w3.org/Graphics/JPEG/itu-t81.pdf
  JPEG_MARKERS =
    [
      JpegMarker.new(?\xc0, 'SOF0',  'non-differential, Huffman coding - Baseline DCT'),
      JpegMarker.new(?\xc1, 'SOF1',  'non-differential, Huffman coding - Extended sequential DCT'),
      JpegMarker.new(?\xc2, 'SOF2',  'non-differential, Huffman coding - Progressive DCT'),
      JpegMarker.new(?\xc3, 'SOF3',  'non-differential, Huffman coding - Lossless (sequential)'),
      JpegMarker.new(?\xc5, 'SOF5',  'differential, Huffman coding - Differential sequential DCT'),
      JpegMarker.new(?\xc6, 'SOF6',  'differential, Huffman coding - Differential progressive DCT'),
      JpegMarker.new(?\xc7, 'SOF7',  'differential, Huffman coding - Differential lossless (sequential)'),
      JpegMarker.new(?\xc8, 'JPG',   'non-differential, arithmetic coding - Reversed for JPEG extensions'),
      JpegMarker.new(?\xc9, 'SOF9',  'non-differential, arithmetic coding - Extended sequential DCT'),
      JpegMarker.new(?\xca, 'SOF10', 'non-differential, arithmetic coding - Progressive DCT'),
      JpegMarker.new(?\xcb, 'SOF11', 'non-differential, arithmetic coding - Lossless (sequential)'),
      JpegMarker.new(?\xcd, 'SOF13', 'differential, arithmetic coding - Differential sequential DCT'),
      JpegMarker.new(?\xce, 'SOF14', 'differential, arithmetic coding - Differential progressive DCT'),
      JpegMarker.new(?\xcf, 'SOF15', 'differential, arithmetic coding - Differential lossless (sequential)'),
      JpegMarker.new(?\xc4, 'DHT',   'Huffman table specification - Define Huffman table(s)'),
      JpegMarker.new(?\xcc, 'DAC',   'Arithmetic coding conditioning specification - Define arithmetic coding conditioning(s)'),
      JpegMarker.new(?\xd0, 'RST0',  'Restart interval termination - Restart with modulo count 0'),
      JpegMarker.new(?\xd1, 'RST1',  'Restart interval termination - Restart with modulo count 1'),
      JpegMarker.new(?\xd2, 'RST2',  'Restart interval termination - Restart with modulo count 2'),
      JpegMarker.new(?\xd3, 'RST3',  'Restart interval termination - Restart with modulo count 3'),
      JpegMarker.new(?\xd4, 'RST4',  'Restart interval termination - Restart with modulo count 4'),
      JpegMarker.new(?\xd5, 'RST5',  'Restart interval termination - Restart with modulo count 5'),
      JpegMarker.new(?\xd6, 'RST6',  'Restart interval termination - Restart with modulo count 6'),
      JpegMarker.new(?\xd7, 'RST7',  'Restart interval termination - Restart with modulo count 7'),
      JpegMarker.new(?\xd8, 'SOI',   'Start of image'),
      JpegMarker.new(?\xd9, 'EOI',   'End of image'),
      JpegMarker.new(?\xda, 'SOS',   'Start of scan'),
      JpegMarker.new(?\xdb, 'DQT',   'Define quantization table(s)'),
      JpegMarker.new(?\xdc, 'DNL',   'Define number of lines'),
      JpegMarker.new(?\xdd, 'DRI',   'Define restart interval'),
      JpegMarker.new(?\xde, 'DHP',   'Define hierarchical progression'),
      JpegMarker.new(?\xdf, 'EXP',   'Expand reference component(s)'),
      JpegMarker.new(?\xe0, 'APP0',  'Reserved for application segments'),
      JpegMarker.new(?\xe1, 'APP1',  'Reserved for application segments'),
      JpegMarker.new(?\xe2, 'APP2',  'Reserved for application segments'),
      JpegMarker.new(?\xe3, 'APP3',  'Reserved for application segments'),
      JpegMarker.new(?\xe4, 'APP4',  'Reserved for application segments'),
      JpegMarker.new(?\xe5, 'APP5',  'Reserved for application segments'),
      JpegMarker.new(?\xe6, 'APP6',  'Reserved for application segments'),
      JpegMarker.new(?\xe7, 'APP7',  'Reserved for application segments'),
      JpegMarker.new(?\xe8, 'APP8',  'Reserved for application segments'),
      JpegMarker.new(?\xe9, 'APP9',  'Reserved for application segments'),
      JpegMarker.new(?\xea, 'APP10', 'Reserved for application segments'),
      JpegMarker.new(?\xeb, 'APP11', 'Reserved for application segments'),
      JpegMarker.new(?\xec, 'APP12', 'Reserved for application segments'),
      JpegMarker.new(?\xed, 'APP13', 'Reserved for application segments'),
      JpegMarker.new(?\xee, 'APP14', 'Reserved for application segments'),
      JpegMarker.new(?\xef, 'APP15', 'Reserved for application segments'),
      JpegMarker.new(?\xf0, 'JPG0',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf1, 'JPG1',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf2, 'JPG2',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf3, 'JPG3',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf4, 'JPG4',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf5, 'JPG5',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf6, 'JPG6',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf7, 'JPG7',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf8, 'JPG8',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xf9, 'JPG9',  'Reserved for JPEG extensions'),
      JpegMarker.new(?\xfa, 'JPG10', 'Reserved for JPEG extensions'),
      JpegMarker.new(?\xfb, 'JPG11', 'Reserved for JPEG extensions'),
      JpegMarker.new(?\xfc, 'JPG12', 'Reserved for JPEG extensions'),
      JpegMarker.new(?\xfd, 'JPG13', 'Reserved for JPEG extensions'),
      JpegMarker.new(?\xfe, 'COM',   'Comment'),
      JpegMarker.new(?\x01, 'TEM',   'For temporary private use in arithmetic coding'),
      # Markers for "Reserved" are from X'FF02' thru X'FFBF' actually, but we have only X'FF02' for this.
      JpegMarker.new(?\x02, 'RES',   'Reserved'),
    ]

  MARKER_BY_SUFFIX = JPEG_MARKERS.map {|a| [a.code_suffix, a]}.to_h

  def initialize(file)
    @data = []

    items = []
    marker = false
    current_marker = nil

    file.read.chars.each do |e|
      if marker
        marker = false
        # "X'FF00' is NOT a marker but X'FF' value"
        if e == ?\x00
          items << ?\xff
          items << ?\x00
          next
        end

        # "X'FFFF' is treated as is
        if e == ?\xff
          items << ?\xff
          items << ?\xff
          next
        end

        if !items.empty?
          current_marker.data_sequence = items.join.b
          items.clear
        end

        current_marker = MARKER_BY_SUFFIX[e].dup
        if current_marker.nil?
          current_marker = JpegMarker.new(e, 'UNK', 'Unknown marker')
        end

        @data << current_marker
        next
      end

      if e == ?\xff
        marker = true
        next
      end
      items << e
    end

    if !items.empty?
      @data << items.join
    end
  end

  def save(dest = 'out.jpg')
    @last_filename = dest
    open(dest, 'w').write(@data.map(&:to_bytes).join)
  end

  def open_file
    if @last_filename.nil?
      STDERR.puts('WARN: No file to open')
      return
    end

    system('open', @last_filename)
  end
  
  def show_list
   @data.each do |e|
     STDERR.puts "= MARKER #{e.code_suffix.b.inspect}: #{e&.symbol} (#{e&.description}) ="
     if e.sequence_in_hex
       STDERR.puts e.sequence_in_hex
     end
   end

   nil
  end
end
end
