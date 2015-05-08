require 'board'

describe Board do
  let(:invalid_coords) {   [:A11, :A0, :K1, :K10] }

  it 'is 10 squares wide' do
    expect(subject.width).to eq 10
  end

  it 'is 10 squares high' do
    expect(subject.height).to eq 10
  end

  context 'when initialized' do
    it 'has no ships' do
      expect(subject.ships).to be_empty
    end
  end

  describe 'place_ship' do
    let(:ship) { double :ship, size: 1 }

    it 'adds a ship to the board' do
      subject.place_ship ship, :A1
      expect(subject.ships).to include ship
    end

    it 'fails if coordinates are invalid' do
      invalid_coords.each do |coord|
        expect { subject.place_ship ship, coord }.to raise_error 'Invalid coordinates'
      end
    end

    it 'handles larger ships' do
      ship = double :ship, size: 4
      subject.place_ship ship, :A1
      [:A1, :B1, :C1, :D1].each do |coord|
        expect(subject[coord]).to be ship
      end
    end
  end

  describe '[]' do
    it 'fails if coordinates are invalid' do
      invalid_coords.each do |coord|
        expect { subject.receive_shot coord }.to raise_error 'Invalid coordinates'
      end
    end
    it 'returns the entry in the grid' do
      subject.place_ship :ship, :C9
      expect(subject[:C9]).to be :ship
    end
  end

  describe 'receive_shot' do
    it 'fails if coordinates are invalid' do
      invalid_coords.each do |coord|
        expect { subject[coord] }.to raise_error 'Invalid coordinates'
      end
    end

    it 'returns :miss for a miss' do
      expect(subject.receive_shot :A1).to eq :miss
    end

    it 'returns :hit for a ship' do
      ship = double :ship, size: 1
      subject.place_ship ship, :A1
      expect(subject.receive_shot :A1).to eq :hit
    end
  end
end
