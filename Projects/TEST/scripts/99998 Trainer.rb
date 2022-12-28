class Interpreter
    def trainer(trainer_id, dialog: 'Let\'s battle!', troop_id: 3, bgm: DEFAULT_TRAINER_BGM, disable: 'A', enable: 'B')
        trainer_eye_sequence(dialog)
        start_trainer_battle(trainer_id, troop_id: troop_id)
    end

    def typeCheck(*types)
        healed = []
        types.map!{|type| data_type(type).id}
        $actors.each do |pokemon|
            next unless pokemon
            pokemon.skills_set.each do |skill|
                if types.include?(skill.type)
                    $scene.display_message_and_wait(pokemon.given_name + " used " + skill.name + "!")
                    return true
                end
            end
        end
        $scene.display_message_and_wait("None of your pokemon can do that.")
    end

    def healer(*types)
        healed = []
        types.map!{|type| data_type(type).id}
        $actors.each do |pokemon|
            next unless pokemon
            if types.include?(pokemon.type1) || types.include?(pokemon.type2)
                healed.push(pokemon)
                pokemon.cure
                pokemon.hp = pokemon.max_hp
                pokemon.skills_set.each do |skill|
                    skill&.pp = skill.ppmax
                end
            end
        end
        if healed.size == 0
            $scene.display_message_and_wait("None of your pokemon like this rest spot.")
        else
            list = ''
            first = true
            if healed.size > 1
                healed.each do |pokemon|
                    list = 'and ' + pokemon.given_name if first
                    list = pokemon.given_name + ', ' + list unless first
                    first = false
                end
                $scene.display_message_and_wait("#{list} feel refreshed.")
            end
            if healed.size == 1
                list = healed[0].given_name
                $scene.display_message_and_wait("#{list} feels refreshed.")
            end
        end
    end

    def forge()
        $scene.display_message_and_wait("The forge is hot and roaring.")
        healer(:fire, :steel)
    end
    def pond()
        $scene.display_message_and_wait("This flower smells like home.")
        healer(:grass, :bug, :fairy, :flying, :normal)
    end
    def mud()
        $scene.display_message_and_wait("There is an underground burrow here! Let's explore!")
        healer(:ground, :ice, :rock, :water)
    end
    def idle()
        $scene.display_message_and_wait("The old gods speak threw this idle. Their voices echo in wispers.")
        healer(:dragon, :dark, :psychic, :ghost, :poison)
    end
    def lamp()
        $scene.display_message_and_wait("The lamp is bright and full of energy.")
        healer(:electric, :bug)
    end
    def lesson()
        $scene.display_message_and_wait("Your team feels good after the battle.")
        healer(:normal, :fighting)
    end

    def rival_one()
        bi = Battle::Logic::BattleInfo.new
        bi.add_party(0, *bi.player_basic_info)
        party = []
        if $game_variables[103] == 1
            party << PFM::Pokemon.generate_from_hash(id: 809, level: 4, trainer_name: 'Noah', trainer_id: 1)
        end
        if $game_variables[103] == 2
            party << PFM::Pokemon.generate_from_hash(id: 806, level: 4, trainer_name: 'Noah', trainer_id: 1)
        end
        if $game_variables[103] == 3
            party << PFM::Pokemon.generate_from_hash(id: 803, level: 4, trainer_name: 'Noah', trainer_id: 1)
        end
        bag = PFM::Bag.new
        bi.add_party(1, party, 'Noah', 'Partner', 'dp_33', bag, 255, 2)
        $scene.call_scene(Battle::Scene, bi)
    end

    def rival_two()
        bi = Battle::Logic::BattleInfo.new
        bi.add_party(0, *bi.player_basic_info)
        party = []
        if $game_variables[103] == 1
            party << PFM::Pokemon.generate_from_hash(id: 246, level: 12, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 519, level: 17, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 810, level: 20, trainer_name: 'Noah', trainer_id: 1)
        end
        if $game_variables[103] == 2
            party << PFM::Pokemon.generate_from_hash(id: 453, level: 12, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 519, level: 17, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 807, level: 20, trainer_name: 'Noah', trainer_id: 1)
        end
        if $game_variables[103] == 3
            party << PFM::Pokemon.generate_from_hash(id: 246, level: 12, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 453, level: 17, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 804, level: 20, trainer_name: 'Noah', trainer_id: 1)
        end
        bag = PFM::Bag.new
        bag.add_item(26, 2)
        bi.add_party(1, party, 'Noah', 'Partner', 'dp_33', bag, 255, 4)
        $scene.call_scene(Battle::Scene, bi)
    end
    def rival_three()
        bi = Battle::Logic::BattleInfo.new
        bi.add_party(0, *bi.player_basic_info)
        party = []
        if $game_variables[103] == 1
            party << PFM::Pokemon.generate_from_hash(id: 247, level: 30, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 521, level: 32, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 810, level: 34, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 181, level: 33, trainer_name: 'Noah', trainer_id: 1)
        end
        if $game_variables[103] == 2
            party << PFM::Pokemon.generate_from_hash(id: 453, level: 30, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 521, level: 32, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 807, level: 34, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 181, level: 33, trainer_name: 'Noah', trainer_id: 1)

        end
        if $game_variables[103] == 3
            party << PFM::Pokemon.generate_from_hash(id: 247, level: 30, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 453, level: 32, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 804, level: 34, trainer_name: 'Noah', trainer_id: 1)
            party << PFM::Pokemon.generate_from_hash(id: 181, level: 33, trainer_name: 'Noah', trainer_id: 1)

        end
        bag = PFM::Bag.new
        bag.add_item(26, 2)
        bi.add_party(1, party, 'Noah', 'Partner', 'dp_33', bag, 255, 4)
        $game_temp.battle_can_lose = true
        $scene.call_scene(Battle::Scene, bi)
    end


    def Ranger_one()
        bi = Battle::Logic::BattleInfo.new
        bi.add_party(0, *bi.player_basic_info)
        party = []
        party << PFM::Pokemon.generate_from_hash(id: 261, level: 10, trainer_name: 'Genna', trainer_id: 1)
        party << PFM::Pokemon.generate_from_hash(id: 821, level: 11, trainer_name: 'Genna', trainer_id: 1)
        party << PFM::Pokemon.generate_from_hash(id: 5, level: 13, shiny: true, trainer_name: 'Genna', trainer_id: 1)
        bag = PFM::Bag.new
        bag.add_item(26, 2)
        bi.add_party(1, party, 'Genna', 'Ranger', 'dp_33', bag, 255, 4)
        $scene.call_scene(Battle::Scene, bi)
    end

    def trade(pokemon_giv, pokemon_get)
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        print($actors[index].id)
        if $actors[index].id == pokemon_giv
            pokemon_get.level = $actors[index].level
            npc_trade_sequence(index, pokemon_get)
            return true
        end
        return false
    end
    def TestSelect()
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        to_steal = []
        $actors.each_with_index{
            |pokemon, i|
            if index != i
                to_steal.push(i)
            end
        }
        steal_pokemon(to_steal)
        return false
    end
    def WakEvo()
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        if $actors[index].id == 105
            add_item(313, true)
            add_item(82, true)
            return true
        end
        return false
    end
    def littleHeal()
        allDead = true
        $actors.each do |pokemon|
            unless pokemon.dead?
                allDead = false
            end
        end
        $actors[0].hp = $actors[0].max_hp / 4 if allDead
    end
    def battle_with_friend(trainer_id, second_trainer_id, friend_trainer_id, bgm: DEFAULT_TRAINER_BGM, disable: 'A', enable: 'B', troop_id: 3, &block)
        start_double_trainer_battle_with_friend(trainer_id, second_trainer_id, friend_trainer_id, bgm: DEFAULT_TRAINER_BGM, disable: 'A', enable: 'B', troop_id: 3, &block)
    end

    def geo()
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 74 || pokemon.id == 75 || pokemon.id == 76
                return true
            end
        end
        return false
    end

    def takeClawjou()
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 810
                steal_pokemon(pokemon)
            end
        end
    end

    def evoClawjou()
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        if $actors[index].type1 != 14 && $actors[index].type2 != 14
            $scene.display_message_and_wait(($actors[index].type1).to_s)
            $scene.display_message_and_wait($actors[index].name + " is not a spirit.")
        else
            $scene.display_message_and_wait($actors[index].name + " is a perfect selection.")
            $scene.display_message_and_wait("Now hand over Clawjou.")
            call_party_menu()
            clawdex = $game_variables[::Yuki::Var::Party_Menu_Sel]
            if $actors[clawdex].id != 810
                retrieve_stolen_pokemon()
                $scene.display_message_and_wait("Come back with your Clawjou.")
            else
            steal_pokemon([index], no_save = true)
            $scene.display_message_and_wait("Let us begin.")
            $scene.display_message_and_wait("Suscita Bestia Muta et Cognosce Locum Tuum!")
            GamePlay.make_pokemon_evolve($actors[clawdex], 811, forced = true)
            steal_pokemon([clawdex])
            return true
            end
        end
        return false
    end
    def evoShoveowl()
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 804
                GamePlay.make_pokemon_evolve(pokemon, 805, forced = true)
            end
        end
    end
    def evoCuridge()
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 807
                GamePlay.make_pokemon_evolve(pokemon, 808, forced = true)
            end
        end
    end

    def traid_evo()
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        id, form = $actors[index].evolve_check(:trade, $actors[index])
        if id
          $scene.display_message_and_wait("Aww, look at the little guy, I hope this wont hurt.")
          Graphics.freeze
          scene = ::GamePlay::Evolve.new($actors[index], id, form, true)
          scene.main  
        else
          $scene.display_message_and_wait("Looks like this one can't void evolve, try reading the wiki harder?")
        end
    end

    def sacrifice()
        call_party_menu()
        index = $game_variables[::Yuki::Var::Party_Menu_Sel]
        if $actors[index].id >= 803 and $actors[index].id <= 811
            $scene.display_message_and_wait("You can't bring your self to do it.")
            return
        end
        max = $actors[index].atk
        largest = "atk"
        $scene.display_message_and_wait("Screams echo all around you.")
        if $actors[index].dfe > max
            max = $actors[index].dfe
            largest = "dfe"
        end
        if $actors[index].ats > max
            max = $actors[index].ats
            largest = "ats"
        end
        if $actors[index].dfs > max
            max = $actors[index].dfs
            largest = "dfs"
        end
        if $actors[index].spd > max
            max = $actors[index].spd
            largest = "spd"
        end
        level = $actors[index].level
        steal_pokemon([index], no_save = true)
        if largest == "atk"
            call_battle_wild(PFM::Pokemon.new(708, level, false, false, 0), 100)
        end
        if largest == "dfe"
            call_battle_wild(PFM::Pokemon.new(355, level, false, false, 0), 100)
        end
        if largest == "ats"
            call_battle_wild(PFM::Pokemon.new(607, level, false, false, 0), 100)
        end
        if largest == "dfs"
            call_battle_wild(PFM::Pokemon.new(592, level, false, false, 0), 100)
        end
        if largest == "spd"
            call_battle_wild(PFM::Pokemon.new(479, level, false, false, 0), 100)
        end
    end
end

module PFM
    class Pokemon
        def clawjou
            if $game_switches[124]
                return true;
            end
            return false;
        end
        def curidge
            if $game_switches[126]
                return true;
            end
            return false;
        end
        def shoveowl
            if $game_switches[125]
                return true;
            end
            return false;
        end
    end
end  