require 'grid'

describe Grid do
    let(:grid) {Grid.new(puzzle)}
  context 'simple puzzle' do
    let(:puzzle){'015003002000100906270068430490002017501040380003905000900081040860070025037204600'}  
    it "should have 81 key value pairs" do
      expect(grid.grid.keys.count).to eq 81
    end

    it "each grid cell should be an instance of the Cell class" do
      expect(grid.grid.values.first.class).to eq(Cell)
    end

    it "each row should have 9 cells" do
      expect(grid.rows.count).to eq 9
    end

    it 'should know that key 50 should be in the 6th row' do
      grid.grid["50"]=1
      expect(grid.rows[5][0]).to eq(1)
    end

    it "each column should have 9 cells" do
      expect(grid.columns.count).to eq 9
    end

    it 'should know that key 05 should be in the 6th col' do
      grid.grid["05"]=1
      expect(grid.columns[5][0]).to eq(1)
    end

    it 'should have 9 unique sectors each 3x3' do
      expect(grid.sectors.count).to eq 9
    end

    it'sector 6 to have permutations of 3,4,5 and 6,7,8' do
      expected = [3,4,5].product([6,7,8]).map {|array| array.join}
      expect(grid.sectors[5]).to eq expected
    end

    it 'should identify the other sector coordinates that 36 is in' do
      expected = [3,4,5].product([6,7,8]).map {|array| array.join}
      expect(grid.find_sector("36")).to eq expected
    end
  end
  context ' solving a simple puzzle' do
    let(:puzzle){'015003002000100906270068430490002017501040380003905000900081040860070025037204600'}  
    it 'should have an initialized grid that takes the puzzle as an argument' do
      expect(grid.rows[0][2].value).to eq(5)
    end
    it 'should take the first unsolved cell and subtract the other values in the row from 1..9' do
      expect(grid.cell_row("00")).to eq [1, 5, 3, 2]
    end
    it 'should take the first unsolved cell and subtract the other values in the column from 1..9' do
      expect(grid.cell_column("00")).to eq [2, 4, 5, 9, 8]
    end
    it 'should take the first unsolved cell and subtract the other values in the sector from 1..9' do
      expect(grid.cell_sector("00")).to eq [1, 5, 2, 7]
    end    
    it 'should take the first unsolved cell and subtract all unavailable options'do
      expect(grid.cell_solve("00")).to eq [6]
    end
    it 'if only one number is available for cell, then it should place this value into the cell' do
      grid.cell_solve("00")
      expect(grid.grid["00"].value).to eq 6
    end
    it 'should replace cell if it has more than one option' do
      grid.cell_solve("03")
      expect(grid.grid["03"].value).to eq 0
    end
    it 'is solved when no 0s remain' do
      grid = Grid.new('615493872348127956279568431496832517521746389783915264952681743864379125137254698')
      expect(grid.solved?).to be_true
    end
    it 'should iterate over every cell until there are no 0s lefts' do
      expect(grid.solved?).to be_false
      grid.solve
      expect(grid.solved?).to be_true
    end
  end
  context 'solving a hard puzzle' do
    let(:puzzle){'800000000003600000070090200050007000000045700000100030001000068008500010090000400'}  
    it 'should return an error if the puzzle cannot be solved'do
      expect{grid.solve}.to raise_error RuntimeError
    end

    it 'should be able to replicate the board' do
      expect(grid.replicate.values.map{|cell| cell.value}).to eq grid.grid.values.map {|cell| cell.value}
    end

    it 'should locate the first cell with more than 1 option' do
      expect(grid.blank_cell).to eq("01")
    end

    it 'should return the range of possible numbers for an unsolved cell' do
      expect(grid.cell_solve("01")). to eq [1,2,4,6]
    end

    it 'should try to solve the first cell with more than 1 option' do
      grid.solve(grid)
      expect(grid.solved?).to be_true
    end







  end
end