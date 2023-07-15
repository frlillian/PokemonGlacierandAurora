Item_list = [
    "Chimchar",
    "Leaf Stone",
    "PanCham",
    "Shiny Stone",
    "Pawniard",
    "Mewtwo"
]

Thresh_list = [
    10,
    30,
    50,
    70,
    100,
    375,
]

Given_list = [
    false,
    false,
    false,
    false,
    false,
    false
]


module PFM

    class << self
        attr_accessor :dna_class
    end

    class DNA

        attr_accessor :game_state

        def initialize (game_state = PFM.game_state)
            @caught = game_state.game_variables[Yuki::Var::Pokedex_Catch]
        end

        def update_caught
            @caught = game_state.game_variables[Yuki::Var::Pokedex_Catch]
        end

        def caught
            @caught
        end
    end

    # class GameState
    #     # The informations about the player and the game
    #     # @return [PFM::Trainer]
    #     attr_accessor :dna
    #     on_player_initialize(:dna) { @dna = PFM.dna_class.new(self) }
    #     on_expand_global_variables(:dna) do
    #         # Variable containing the Trainer (card) information
    #         $dna = @dna
    #         @dna.game_state = self
    #     end
    # end
end

PFM.dna_class = PFM::DNA



module GamePlay
    class << self
        attr_accessor :dna_class
        def open_DNA
            current_scene.call_scene(dna_class)
        end
    end

    class DNA < BaseCleanUpdate::FrameBalanced
        attr_accessor :dna_class
        def initialize
            super(false)
        end

        def update_graphics
            @base_ui.update_background_animation
        end

        def create_graphics
            create_viewport
            create_base_ui
            create_sub_background
            create_items
            create_texts
            create_item_sprites
            prize_check
        end

        def update_inputs
            return @running = false if Input.trigger?(:B)
            return true
        end
      
        def create_base_ui
            @base_ui = UI::GenericBase.new(@viewport, button_texts)
            @mouse_button_cancel = @base_ui.ctrl.last
        end

        def button_texts
            return [nil, nil, nil, ext_text(9000, 115)]
        end

        def create_sub_background
            @sub_background = Sprite.new(@viewport).set_bitmap('DNAShop/frame', :interface)
        end

        def prize_check
            Item_list.each_with_index do |item, index|
                if Thresh_list[index] <= PFM.game_state.game_variables[Yuki::Var::Pokedex_Catch]
                    if not Given_list[index]
                        if game_state.game_switches[154]
                            display_message("Hey it's Lary. Looks like you've got enough DNA for an item.")
                        else
                            display_message("Hey it's the Professor. Looks like you've got enough DNA for an item.")
                        end
                        display_message("Transferring it to your account now...")
                        if index == 0
                            $game_system.battle_interpreter.add_rename_pokemon(390, 10, false)
                        elsif index == 1
                            $game_system.battle_interpreter.add_item(85, true)
                        elsif index == 2
                            $game_system.battle_interpreter.add_rename_pokemon(674, 30, false)
                        elsif index == 3
                            $game_system.battle_interpreter.add_item(107, true)
                        elsif index == 4
                            $game_system.battle_interpreter.add_rename_pokemon(624, 50, false)
                        elsif index == 5
                            $game_system.battle_interpreter.add_rename_pokemon(150, 60, false)
                            display_message("The rebellion's hopes lie with you.")
                        end
                    end
                    Given_list[index] = true
                end
            end

        end


        def create_items
            Item_list.each_with_index do |item, index|
                if Thresh_list[index] > PFM.game_state.game_variables[Yuki::Var::Pokedex_Catch]
                    @items = Sprite.new(@viewport).set_bitmap('DNAShop/Item_frame', :interface)
                    @items.set_position(index<3 ? (index)*100+15 : (index - 3)*100+15, index<3 ? 50 : 100)
                else
                    @items = Sprite.new(@viewport).set_bitmap('DNAShop/Item_frame_blue', :interface)
                    @items.set_position(index<3 ? (index)*100+15 : (index - 3)*100+15, index<3 ? 50 : 100)
                end
            end
        end

        def create_texts
            @texts = UI::SpriteStack.new(@viewport)
            Item_list.each_with_index do |item, index|
                @texts.add_text(index<3 ? (index)*100-125 : (index - 3)*100-125, index<3 ? 88 : 138, 225, 10, item, 2, color: 9)
            end
            Thresh_list.each_with_index do |item, index|
                @texts.add_text(index<3 ? (index)*100-125 : (index - 3)*100-125, index<3 ? 70 : 120, 225, 15, item.to_s, 2, color: 9)
            end
        end

        def create_item_sprites
            @sprites = Array.new(6) do |index|
                sprite = Sprite.new(@viewport).set_bitmap('DNAShop/'+(index+1).to_s, :interface)
                sprite.set_position(index<3 ? (index)*100+15 : (index - 3)*100+15, index<3 ? 52 : 102)
                sprite.visible = true
              next(sprite)
            end
        end
    end
end

GamePlay.dna_class = GamePlay::DNA



        # module UI
#     module DNA
#         class DNAScene < SpriteStack

#             BACKGROUND = 'DNAShop/frame'

#             COORDINATES = [0,198]

#             def initialize (viewport)
#                 super(viewport, *COORDINATES)
#                 init_sprite
#             end

#             def init_sprite()
#                 add_background(BACKGROUND).set_z(1)
#                 @text = create_text
#             end

#             def create_text
#                 text = add_text(5, 6, 87, 13, nil.to_s, 1, color: 10)
#                 text.z = 2
#                 return text
#             end
#         end

#         class DNAItemList < SpriteStack

#             BACKGROUND = 'DNAShop/Item_frame'

#             BASE_X = 191

#             BASE_Y = 18

#             BUTTON_OFFSET = 25

#             def initialize (viewport)
#                 super(6) do |i|
#                     DNAItem.new(viewport, i)
#                 end
#                 init_sprite
#             end

#             def create_text
#                 text = add_text(5, 6, 87, 13, nil.to_s, 1, color: 10)
#                 text.z = 2
#                 return text
#             end

#             class DNAItem < SpriteStack

#                 item_list = [
#                     "Chimchar",
#                     "Leaf Stone",
#                     "PanCham",
#                     "Shiny Stone",
#                     "Pawniard",
#                     "Mewtwo"
#                 ]

#                 def initialize (viewport, index)
#                     @index = index
#                     super(viewport, BASE_X, BASE_Y + BUTTON_OFFSET * index)
#                     create_background
#                     item_list[@index] = create_text
#                 end
#             end
#         end
#     end
# end