require 'fixtures/example'

describe ObjectTree do
  describe 'examples' do
    it 'no happen infinity loop' do
      expect(ObjectTree.create(BasicObject)).not_to be_nil
    end

    it 'test case 1' do
      expect =<<-EXPECT
<C> Case1::A
└───── <C> Case1::B
        └───── <C> Case1::C
      EXPECT

      expect(ObjectTree.create(Case1::A).to_s.uncolorize).to eq(expect)
    end

    it 'test case 2' do
      expect =<<-EXPECT
<M> Case2::A
└───── <C> Case2::B
      EXPECT

      expect(ObjectTree.create(Case2::A).to_s.uncolorize).to eq(expect)
    end

    it 'test case 3' do
      expect =<<-EXPECT
<C> Case3::A
├───── <C> Case3::C
└───── <C> Case3::B
      EXPECT

      expect(ObjectTree.create(Case3::A).to_s.uncolorize).to eq(expect)
    end

    it 'test case 4' do
      expect =<<-EXPECT
<M> Case4::D
└───── <C> Case4::A
        ├───── <M> Case4::E
        │       └───── <C> Case4::C
        └───── <C> Case4::B
      EXPECT

      expect(ObjectTree.create(Case4::D).to_s.uncolorize).to eq(expect)
    end

    it 'test case 5' do
      expect =<<-EXPECT
<M> Case5::D
└───── <C> Case5::A
        ├───── <C> Case5::B
        │       └───── <M> Case5::E
        │               └───── <C> Case5::F
        └───── <M> Case5::E
                └───── <C> Case5::C
      EXPECT

      expect(ObjectTree.create(Case5::D).to_s.uncolorize).to eq(expect)
    end
  end
end
