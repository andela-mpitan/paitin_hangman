require 'spec_helper'
  
describe PaitinHangman::GameResumption do
  class Dummys < PaitinHangman::GameResumption
    def initialize(test = false)
      super() unless test
    end
    def initialize_cont(name, test = false)
      super(name) if test
    end
    def all_games
      [PaitinHangman::GameData.new("player_name", ['m', 'i', 's', 's', 'e', 's'], %w{r i g h t g u e s s e s},
                                             "chances", "word_control", "gameword", "count")]
    end
  end
  before :each do
    @instance = Dummys.new(true)
  end

  describe '#new' do
    it 'returns a new game object' do
      allow(STDIN).to receive(:gets).and_return("SIMON")
      expect(Dummys.new).to be_a Dummys
    end

    it 'throws an error when instantiated with less than seven parameters' do
      expect{PaitinHangman::GameResumption.new "lala", "in the mighty"}.to raise_error ArgumentError
    end
  end

  describe "#initialize_cont" do
    context "checkes whether a name given has a saved game" do
      before do
        @instance.instance_variable_set("@saved_game", [])
        allow(@instance).to receive(:exit).and_return(nil)
      allow(@instance).to receive(:print_history).and_return(nil)
      allow(@instance).to receive(:choice_integrities).and_return(nil)
      end
      
      specify { expect { @instance.initialize_cont("Mayowa", true) }.to output("You have no saved game with that name".red + "\n" + "START A NEW GAME INSTEAD".yellow + "\n" + "Here are the saved games found for Mayowa\n\n").to_stdout }
    end
  end

  describe "#choice_integrities" do
    it "ensures the user types the game that he wants" do
      allow(STDIN).to receive(:gets).and_return("5", "2")
      @instance.instance_variable_set("@saved_game", ["a", "b", "c", "d"])
      allow(@instance).to receive(:load_properties).and_return("properties")
      expect(@instance.choice_integrities).to eql "properties"
    end
  end
  describe '#load_properties' do
    
    before :each do
      @dummy = PaitinHangman::GameData.new("player_name", ['m', 'i', 's', 's', 'e', 's'], %w{r i g h t g u e s s e s},
                                             "chances", "word_control", "gameword", "count")
    end
    it "sets the game properties" do
      @instance.instance_variable_set("@saved_game", [1, 2, @dummy, 4])
      @instance.instance_variable_set("@choice", 2)
      allow(@instance).to receive(:load_properties_cont).and_return "trials"
      expect(@instance.load_properties).to eql "trials"
    end
  end

  describe '#load_properties_cont' do
    before :each do
      @dummy = PaitinHangman::GameData.new("player_name", ['m', 'i', 's', 's', 'e', 's'], %w{r i g h t g u e s s e s},
                                             "chances", "word_control", "gameword", "count")
    end
    it "sets the property of count and return trials" do
      @instance.instance_variable_set("@game_object", @dummy)
      allow(@instance).to receive(:trials).and_return("game")
      expect(@instance.load_properties_cont).to eql "game"
    end
  end

  describe '#print_function' do
    context "It should print the right message to the screen" do
      before do
        @dummy = PaitinHangman::GameData.new("player_name", ['m', 'i', 's', 's', 'e', 's'], %w{r i g h t g u e s s e s},
                                             "chances", "word_control", "gameword", "count")
        @instance.instance_variable_set("@saved_game", [@dummy])
      end
      specify { expect { @instance.print_function }.to output("1.\tplayer_name  ===>>>     WORD__ CONTROL\n\t   chances chances left and you have used m, i, s, s, e, s\n\n").to_stdout }
    end
  end

  describe '#trials' do
    it 'can run a resumed game successfully' do
      @instance.instance_variable_set("@word_control", "_i__i_i__")
      allow(@instance).to receive(:verify_guess).and_return(nil)
      allow(@instance).to receive(:compare_guess).and_return(nil)
      allow(@instance).to receive(:win_game).and_return(nil)
      allow(@instance).to receive(:end_game).and_return(nil)
      expect(@instance.trials(10)).to eql nil
    end
  end

  describe '#setup' do
    context "it can print the game status to the screen" do
      before do
        @instance.instance_variable_set("@word_control", "_i__i_i__")
      end
      specify { expect { @instance.setup }.to output("Now, continue playing...\n__ I__ __ I__ I__ __ \n").to_stdout }
    end
  end
end