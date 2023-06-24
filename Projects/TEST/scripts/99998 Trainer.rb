class Interpreter
    def trainer(trainer_id, dialog: 'Let\'s battle!', troop_id: 3, bgm: DEFAULT_TRAINER_BGM, disable: 'A', enable: 'B')
        trainer_eye_sequence(dialog)
        start_trainer_battle(trainer_id, troop_id: troop_id, bgm: bgm)
    end

    def Lugia()
      if $actors[index].id == pokemon_giv
        pokemon_get.level = $actors[index].level
        npc_trade_sequence(index, pokemon_get)
        return true
      end
    end

    def lava_fire()
      index = rand(0..5)
      $actors[index].status_burn(true)
    end

    def lava_rock()
      index = rand(0..5)
      $actors[index].hp = $actors[index].hp - 40
    end

    def tutor(skill)
      call_party_menu()
      index = $game_variables[::Yuki::Var::Party_Menu_Sel]
      if $actors[index].skill_learnt?(skill)
        $scene.display_message_and_wait($actors[index].given_name + " already knows this move!")
      else
        skill_learn($actors[index], skill)
      end
    end
    def all_sleep()
        $actors.each do |pokemon|
            pokemon.status_sleep(true)
        end
    end
    def all_burn()
      $actors.each do |pokemon|
          pokemon.status_burn(true)
      end
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
        $scene.display_message_and_wait("The fire is hot and roaring.")
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
        $scene.display_message_and_wait("The old gods speak through this idol. Their voices echo in whispers.")
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
        party << PFM::Pokemon.generate_from_hash(id: 261, level: 16, trainer_name: 'Genna', trainer_id: 1)
        party << PFM::Pokemon.generate_from_hash(id: 821, level: 16, trainer_name: 'Genna', trainer_id: 1)
        party << PFM::Pokemon.generate_from_hash(id: 5, level: 18, shiny: true, trainer_name: 'Genna', trainer_id: 1)
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

    def evoBulb(light=false)
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 1 and pokemon.form != 0
              if light
                if pokemon.form == 1
                  GamePlay.make_pokemon_evolve(pokemon, 2, form = 1, forced = true)
                  return true
                else
                  GamePlay.make_pokemon_evolve(pokemon, 2, form = 2, forced = true)
                  return true
                end
              else
                if pokemon.form == 1
                  GamePlay.make_pokemon_evolve(pokemon, 2, form = 3, forced = true)
                  return true
                else
                  GamePlay.make_pokemon_evolve(pokemon, 2, form = 4, forced = true)
                  return true
                end
              end
            end
        end
        return false
    end

    def evoIvy(cold=false)
        $actors.each do |pokemon|
            next unless pokemon
            if pokemon.id == 2 and pokemon.form != 0
                if cold
                  if pokemon.form == 1
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 6, forced = true)
                    return true
                  elsif pokemon.form == 2
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 7, forced = true)
                    return true
                  elsif pokemon.form == 3
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 8, forced = true)
                    return true
                  else
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 9, forced = true)
                    return true
                  end
                else
                  if pokemon.form == 1
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 2, forced = true)
                    return true
                  elsif pokemon.form == 2
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 3, forced = true)
                    return true
                  elsif pokemon.form == 3
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 4, forced = true)
                    return true
                  else
                    GamePlay.make_pokemon_evolve(pokemon, 3, form = 5, forced = true)
                    return true
                  end
                end
            end
        end
        return false
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
        $scene.display_message_and_wait("You're Pokemon serves the Gods now. The Gods Reward you.")
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
        # if $actors[index].hp > max
        #     max = $actors[index].hp
        #     largest = "hp"
        # end
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
            call_battle_wild(PFM::Pokemon.new(622, level, false, false, 0), 100)
        end
        if largest == "ats"
            call_battle_wild(PFM::Pokemon.new(607, level, false, false, 0), 100)
        end
        if largest == "dfs"
            call_battle_wild(PFM::Pokemon.new(355, level, false, false, 0), 100)
        end
        if largest == "spd"
            call_battle_wild(PFM::Pokemon.new(425, level, false, false, 0), 100)
        end
        if largest == "hp"
            call_battle_wild(PFM::Pokemon.new(622, level, false, false, 0), 100)
        end
    end
end

module PFM
    class GameState
        def loyalty_update
            return unless (@steps - (@steps / 64) * 64) == 0
            return if cant_process_event_tasks?
      
            @actors.each do |pokemon|
              value = pokemon.loyalty < 200 ? 2 : 1
              value *= 2 if data_item(pokemon.captured_with).db_symbol == :luxury_ball
              value *= 1.5 if pokemon.item_db_symbol == :soothe_bell
              pokemon.loyalty += value.floor
            end
          end      
    end
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
        ShotItem = %i[__undef__ long_barrelattachment explosive_shot]
        FORM_CALIBRATE[:insurvern] = proc { @form = ShotItem.index(item_db_symbol).to_i }
        FORM_CALIBRATE[:blastoise] = proc { @form = ShotItem.index(item_db_symbol).to_i }
    end
end  

module Battle
    class Logic
      class WeatherChangeHandler < ChangeHandlerBase
        WEATHER_SYM_TO_MSG = {
        none: 97,
        rain: 88,
        sunny: 87,
        sandstorm: 89,
        hail: 90,
        fog: 91,
        hardsun: 271,
        hardrain: 269,
        wind: 273,
        time: 288
      }
    end
      # Class responsive of calculating experience & EV of Pokemon when a Pokemon faints
      class ExpHandler

        def exp_multipliers(receiver)
            aura_factor = aura_factor(receiver)
            lucky_factor = receiver.item_db_symbol == :lucky_egg ? 1.5 : 1
            trade_factor = receiver.from_player? ? 1 : 1
            loyalty_factor = happy?(receiver) ? 1 : 1
            evolution_factor = receiver.evolve_check(:level_up) ? 1 : 1
            return aura_factor * lucky_factor * trade_factor * loyalty_factor * evolution_factor * 0.85
        end
    
    end
    end
    class Move
      class WeatherMove < Move
        WEATHER_MOVES = {
          rain_dance: :rain,
          sunny_day: :sunny,
          sandstorm: :sandstorm,
          hail: :hail,
          drake_call: :time
        }
        WEATHER_ITEMS = {
          rain_dance: :damp_rock,
          sunny_day: :heat_rock,
          sandstorm: :smooth_rock,
          hail: :icy_rock,
          drake_call: :none
        }
  
        private
  
        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_effect(user, actual_targets)
          nb_turn = user.hold_item?(WEATHER_ITEMS[db_symbol]) ? 8 : 5
          if WEATHER_MOVES[db_symbol] == :drake_call
            nb_turn = 8
          end
          logic.weather_change_handler.weather_change_with_process(WEATHER_MOVES[db_symbol], nb_turn)
          # TODO: Add animations into the weather_change_handler
        end
      end
  
        class RelicBlast < Basic
            TYPES = {
                relic_crown: :dragon,
                relic_statue: :fighting,
                relic_band: :water,
                relic_vase: :fire
              }

            TYPES.default = :ghost
            def deal_effect(user, actual_targets)
                if new_type != data_type(:ghost).id
                    old_typ = user.type3
                    user.type3 = new_type
                    if old_typ != new_type
                        scene.display_message_and_wait(message(user))
                    end
                end
            end
            def new_type
                for i in 0..5 do
                    if @scene.logic.battler(0, i).id == 816
                        return data_type(TYPES[@scene.logic.battler(0, i).item_db_symbol] || 0).id
                    end
                end
                return data_type(:ghost).id
            end
            def type
                return new_type
            end
            def message(target)
                return parse_text_with_pokemon(19, 902, target, '[VAR TYPE(0001)]' => data_type(new_type).name)
            end
        Move.register(:s_relic_blast, RelicBlast)
        end

        class DrakeRenaissance < Basic
            def deal_effect(user, actual_targets)
                user.type3 = type
                scene.display_message_and_wait(message(user))
            end
            def type
                return data_type(:dragon).id
            end
            def message(target)
                return parse_text_with_pokemon(19, 902, target, '[VAR TYPE(0001)]' => data_type(type).name)
            end
        Move.register(:s_drake_renaissance, DrakeRenaissance)
        end
        class AncientPower < Basic
          def effect_chance
            return 50 if $env.time?
            return data.effect_chance == 0 ? 100 : data.effect_chance
          end
          def deal_stats(user, actual_targets)
            super(user, [user])
          end    
        Move.register(:s_ancient_power, AncientPower)
    end
end

    module Effects
      class Ability
        class Dry < Ability
          def spd_modifier
            return $env.sunny? ? 1.5 : 1
          end
        end
        register(:dry_processed, Dry)

        class Wet < Ability
          def spd_modifier
            return $env.rain? ? 1.5 : 1
          end
        end
        register(:wet_processed, Wet)

        class LightRoastedDry < Dry
          def sp_atk_multiplier(user, target, move)
            return 1 if not move.physical?    
            return 1.2
          end

        end
        register(:fruity_notes, LightRoastedDry)

        class LightRoastedWet < Wet
          def sp_atk_multiplier(user, target, move)
            return 1 if not move.physical?    
            return 1.2
          end

        end
        register(:nutty_notes, LightRoastedWet)

        class DarkRoastedDry < Dry
          def chance_of_hit_multiplier(user, target, move)
            return 1 if user != @target
  
            return 1.3
          end
  
        end
        register(:caramelly_notes, DarkRoastedDry)

        class DarkRoastedWet < Wet
          def chance_of_hit_multiplier(user, target, move)
            return 1 if user != @target
  
            return 1.3
          end
  
        end
        register(:mapley_notes, DarkRoastedWet)

        class LightRoastedDryDrip < LightRoastedDry
          def on_post_damage(handler, hp, target, launcher, skill)
            return if launcher != @target || launcher == target
            return unless skill&.direct? && launcher.hp > 0 && target.can_be_burn? && bchance?(0.2, @logic)
  
            handler.scene.visual.show_ability(launcher)
            handler.logic.status_change_handler.status_change_with_process(:burn, target)
          end
  
        end
        register(:fruity_drip, LightRoastedDryDrip)

        class LightRoastedWetDrip < LightRoastedWet
          def on_post_damage(handler, hp, target, launcher, skill)
            return if launcher != @target || launcher == target
            return unless skill&.direct? && launcher.hp > 0 && target.can_be_burn? && bchance?(0.2, @logic)
  
            handler.scene.visual.show_ability(launcher)
            handler.logic.status_change_handler.status_change_with_process(:burn, target)
          end

        end
        register(:nutty_drip, LightRoastedWetDrip)

        class DarkRoastedDryDrip < DarkRoastedDry  
          def on_post_damage(handler, hp, target, launcher, skill)
            return if launcher != @target || launcher == target
            return unless skill&.direct? && launcher.hp > 0 && target.can_be_burn? && bchance?(0.2, @logic)
  
            handler.scene.visual.show_ability(launcher)
            handler.logic.status_change_handler.status_change_with_process(:burn, target)
          end

        end
        register(:caramelly_drip, DarkRoastedDryDrip)

        class DarkRoastedWetDrip < DarkRoastedWet
          def on_post_damage(handler, hp, target, launcher, skill)
            return if launcher != @target || launcher == target
            return unless skill&.direct? && launcher.hp > 0 && target.can_be_burn? && bchance?(0.2, @logic)
  
            handler.scene.visual.show_ability(launcher)
            handler.logic.status_change_handler.status_change_with_process(:burn, target)
          end

        end
        register(:mapley_drip, DarkRoastedWetDrip)

        class LightRoastedDryCold < LightRoastedDry
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(@target) && $env.hail?
            return if @target.hp == @target.max_hp
            return if @target.dead?
  
            scene.visual.show_ability(@target)
            logic.damage_handler.heal(target, target.max_hp / 16)
          end  
        end
        register(:fruity_cold_brew, LightRoastedDryCold)
        class LightRoastedWetCold < LightRoastedWet
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(@target) && $env.hail?
            return if @target.hp == @target.max_hp
            return if @target.dead?
  
            scene.visual.show_ability(@target)
            logic.damage_handler.heal(target, target.max_hp / 16)
          end  
        end
        register(:nutty_cold_brew, LightRoastedWetCold)
        class DarkRoastedDryCold < DarkRoastedDry
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(@target) && $env.hail?
            return if @target.hp == @target.max_hp
            return if @target.dead?
  
            scene.visual.show_ability(@target)
            logic.damage_handler.heal(target, target.max_hp / 16)
          end  
        end
        register(:caramelly_cold_brew, DarkRoastedDryCold)

        class DarkRoastedWetCold < DarkRoastedWet
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(@target) && $env.hail?
            return if @target.hp == @target.max_hp
            return if @target.dead?
  
            scene.visual.show_ability(@target)
            logic.damage_handler.heal(target, target.max_hp / 16)
          end  
        end
        register(:mapley_cold_brew, DarkRoastedWetCold)
        
        class SoftSkin < Ability
          # # Get the base power multiplier of this move
          # # @param user [PFM::PokemonBattler]
          # # @param target [PFM::PokemonBattler]
          # # @param move [Battle::Move]
          # # @return [Float]
          def base_power_multiplier(user, target, move)
            return 1 if user != self.target
            return move.type == data_type(:water).id ? 1.25 : 1
          end
  
          # Function called when a damage_prevention is checked
          # @param handler [Battle::Logic::DamageHandler]
          # @param hp [Integer] number of hp (damage) dealt
          # @param target [PFM::PokemonBattler]
          # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
          # @param skill [Battle::Move, nil] Potential move used
          # @return [:prevent, Integer, nil] :prevent if the damage cannot be applied, Integer if the hp variable should be updated
          def on_damage_prevention(handler, hp, target, launcher, skill)
            return unless skill&.type_fire? && target == self.target
            return unless launcher.can_be_lowered_or_canceled?
  
            return handler.prevent_change do
              handler.scene.visual.show_ability(target)
              handler.logic.damage_handler.heal(target, target.max_hp / 4)
            end
          end
  
          # Function called at the end of a turn
          # @param logic [Battle::Logic] logic of the battle
          # @param scene [Battle::Scene] battle scene
          # @param battlers [Array<PFM::PokemonBattler>] all alive battlers
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(target)
            return if target.dead?
  
            if $env.sunny? || $env.hardsun?
              scene.visual.show_ability(target)
              logic.damage_handler.heal(target, target.max_hp / 8)
            elsif $env.rain? || $env.hardrain?
              scene.visual.show_ability(target)
              logic.damage_handler.damage_change((target.max_hp / 8).clamp(1, Float::INFINITY), target)
            end
          end
        end
        register(:soft_skin, SoftSkin)
  
        class BoostingMoveType < Ability
          register(:assassin, :dark)
          register(:sludge_born, :poison)
        end
        class AncientDragonCall < Ability
            def on_switch_event(handler, who, with)
                return if with != @target
      
                weather_handler = handler.logic.weather_change_handler
                return unless weather_handler.weather_appliable?(weather)
      
                handler.scene.visual.show_ability(with)
                nb_turn = with.hold_item?(item_db_symbol) ? 13 : 8
                weather_handler.weather_change(weather, nb_turn)
                # handler.scene.visual.show_rmxp_animation(with, animation_id)
            end
      
            private
    
            # Tell the weather to set
            # @return [Symbol]
            def weather
              return :time
            end
    
            # Tell which item increase the turn count
            # @return [Symbol]
            def item_db_symbol
              return 1
            end

            # def on_damage_prevention(handler, hp, target, launcher, skill)
            #   return if target != @target
    
            #   if %i[rain_dance sunny_day hail sandstorm].include?(skill&.db_symbol)
            #     return handler.prevent_change do
            #       handler.scene.visual.show_ability(target)
            #       handler.scene.display_message_and_wait(parse_text_with_pokemon(18, 289, target))
            #     end
            #   end
            # end

            # def on_weather_prevention(handler, weather_type, last_weather)
            #   return if weather_type == :time
    
            #   return handler.prevent_change do
            #     handler.scene.visual.show_ability(@target)
            #     handler.scene.display_message_and_wait(parse_text_with_pokemon(18, 289, target))
            #   end
            # end
    
    
            # Tell which animation to play
            # @return [Integer]
            def animation_id
              494
            end
        end
        register(:ancient_dragon_call, AncientDragonCall)
      end
      class Item
        class LongBarrelAttachment < Item
          # Return the chance of hit multiplier
          # @param user [PFM::PokemonBattler] user of the move
          # @param target [PFM::PokemonBattler] target of the move
          # @param move [Battle::Move]
          # @return [Float]
          def chance_of_hit_multiplier(user, target, move)
            return 1 if user != @target
            return 1 if user.db_symbol != :insurvern && user.db_symbol != :blastoise
  
            return 1.2
          end
        end
        class TerraHeart < Item
          # List of types to for each item that terras
          TYPE = {
            hear_of_the_tundra: :ice,
            on_board_ai: :electric,
            stone_flower: :ground
          }
          MESSAGE = {
            hear_of_the_tundra: "The air grows cold ",
            on_board_ai: "Transistors clatter ",
            stone_flower: "The earth quakes "
          }

          ANIMATION = {
            hear_of_the_tundra: 360,
            on_board_ai: 86,
            stone_flower: 683
          }

          # Saving original types of the pokemon
          @TYPE1 = data_type(:none).id
          @TYPE2 = data_type(:none).id
          def on_switch_event(handler, who, with)
            return if with != @target
            @TYPE1 = data_type(with.type1).id
            @TYPE2 = data_type(with.type2).id
            with.type1 = data_type(TYPE[db_symbol]).id
            with.type2 = data_type(:none).id
            @logic.scene.display_message_and_wait( MESSAGE[db_symbol] + "as " + with.name + " Terastallizes!")
            @logic.scene.visual.show_rmxp_animation(@target, ANIMATION[db_symbol])
          end
          def on_end_turn_event(logic, scene, battlers)
            return unless battlers.include?(@target)
            return if @target.dead?

            @logic.scene.visual.show_rmxp_animation(@target, ANIMATION[db_symbol])
          end
          def sp_atk_multiplier(user, target, move)
            if (@TYPE1 == data_type(TYPE[db_symbol]).id || @TYPE2 == data_type(TYPE[db_symbol]).id) and move.type == data_type(TYPE[db_symbol]).id
              return 2
            end
            if move.type == @TYPE1 || move.type == @TYPE2
              return 1.5
            end
            return 1
          end
        end
  
    #   class HeartOfTheTundra < Item
    #     @TYPE1 = data_type(:none).id
    #     @TYPE2 = data_type(:none).id
    #     def on_switch_event(handler, who, with)
    #       return if with != @target
    #       @TYPE1 = data_type(with.type1).id
    #       @TYPE2 = data_type(with.type2).id
    #       with.type1 = data_type(:ice).id
    #       with.type2 = data_type(:none).id
    #       @logic.scene.display_message_and_wait("The air grows cold as " + with.name + " Terastallizes!")
    #       @logic.scene.visual.show_rmxp_animation(@target, 360)
    #     end
    #     def on_end_turn_event(logic, scene, battlers)
    #       return unless battlers.include?(@target)
    #       return if @target.dead?

    #       @logic.scene.visual.show_rmxp_animation(@target, 360)
    #     end
    #     def sp_atk_multiplier(user, target, move)
    #       if (@TYPE1 == data_type(:ice).id || @TYPE2 == data_type(:ice).id) and move.type == data_type(:ice).id
    #         return 2
    #       end
    #       if move.type == @TYPE1 || move.type == @TYPE1
    #         return 1.5
    #       end
    #       return 1
    #     end
    # end

        register(:long_barrelattachment, LongBarrelAttachment)
        register(:hear_of_the_tundra, TerraHeart)
        register(:on_board_ai, TerraHeart)
        register(:stone_flower, TerraHeart)
      end
    class Weather
      class Hail < Weather
        # List of abilities that blocks hail damages
        HAIL_BLOCKING_ABILITIES = %i[magic_guard ice_body snow_cloak overcoat fruity_cold_brew nutty_cold_brew mapley_cold_brew caramelly_cold_brew]
        # Function called at the end of a turn
        # @param logic [Battle::Logic] logic of the battle
        # @param scene [Battle::Scene] battle scene
        # @param battlers [Array<PFM::PokemonBattler>] all alive battlers
        def on_end_turn_event(logic, scene, battlers)
          if $env.decrease_weather_duration
            scene.display_message_and_wait(parse_text(18, 95))
            logic.weather_change_handler.weather_change(:none, 0)
          else
            scene.visual.show_rmxp_animation(battlers.first || logic.battler(0, 0), 495)
            scene.display_message_and_wait(parse_text(18, 99))
            battlers.each do |battler|
              next if battler.type_ice?
              next if battler.dead?
              next if HAIL_BLOCKING_ABILITIES.include?(battler.battle_ability_db_symbol)

              logic.damage_handler.damage_change((battler.max_hp / 16).clamp(1, Float::INFINITY), battler)
            end
          end
        end
      end
      register(:hail, Hail)

      class Time < Weather
        # List of abilities that blocks sandstorm damages
        TIME_BLOCKING_ABILITIES = %i[magic_guard overcoat]
        # Function called at the end of a turn
        # @param logic [Battle::Logic] logic of the battle
        # @param scene [Battle::Scene] battle scene
        # @param battlers [Array<PFM::PokemonBattler>] all alive battlers
        def on_end_turn_event(logic, scene, battlers)
            if $env.decrease_weather_duration
                scene.display_message_and_wait("The echos faid...")
                logic.weather_change_handler.weather_change(:none, 0)
            else
                # scene.visual.show_rmxp_animation(battlers.first || logic.battler(0, 0), 494)
                scene.display_message_and_wait("Echos of fallen titans sound across the battle field. Their kin rejoyce.")
                battlers.each do |battler|
                if battler.type_dragon?
                    logic.damage_handler.heal(battler, (battler.max_hp / 8).clamp(1, Float::INFINITY))
                    next
                end
            end
            end
        end

        # Give the move [Spe]def mutiplier
        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] target of the move
        # @param move [Battle::Move] move
        # @return [Float, Integer] multiplier
        def sp_atk_multiplier(user, target, move)
        # return 1 if not move.physical?
            return 1 unless user.type_dragon?

            return 1.25
        end
      end
      register(:time, Time)
    end
  end
end


module BattleEngine
    module Abilities
      module_function
      #===
      #> Abilities that act on Pokémon launch
      #===
      UnTracableAbilities = [122, 104, 175]
      def on_launch_ability(pkmn, switched = false)
        enemies = BattleEngine::get_enemies!(pkmn)
        enemy = nil
        if has_ability_usable(pkmn, pkmn.ability)
          case pkmn.ability
          when 11 #> Intimidate
            if switched #> When the Pokémon is switched
              _mp([:ability_display, pkmn])
              enemies.each { |enemy| _mp([:change_atk, enemy, -1]) }
            end
          when 69 #> Trace
            unless enemy_has_ability_usable(pkmn, 69)
              target = BattleEngine::_random_target_selection(pkmn, nil)
              unless UnTracableAbilities.include?(target.ability)
                _mp([:ability_display, pkmn])
                _mp([:set_ability, pkmn, target.ability])
                _msgp(19, 381, target, ::PFM::Text::ABILITY[1] => target.ability_name)
              end
            end
          when 72 #> Pressure
            _mp([:ability_display, pkmn])
            _msgp(19, 487, pkmn)
          when 107 #> Drizzle
            if ::GameData::Flag_4G
              nb_turn = 1/0.0
            else
              nb_turn = BattleEngine::_has_item(pkmn, 285) ? 8 : 5 #> Damp Rock
            end
            _mp([:ability_display, pkmn])
            _mp([:weather_change, :rain, nb_turn])
            _mp([:global_animation, 493])
          when 108 #> Drought
            if ::GameData::Flag_4G
              nb_turn = 1/0.0
            else
              nb_turn = BattleEngine::_has_item(pkmn, 284) ? 8 : 5 #> Heat Rock
            end
            _mp([:ability_display, pkmn])
            _mp([:weather_change, :sunny, nb_turn])
            _mp([:global_animation, 492])
          when 87 #> Sand Stream
            if ::GameData::Flag_4G
              nb_turn = 1/0.0
            else
              nb_turn = BattleEngine::_has_item(pkmn, 283) ? 8 : 5 #> Smooth Rock
            end
            _mp([:ability_display, pkmn])
            _mp([:weather_change, :sandstorm, nb_turn])
            _mp([:global_animation, 494])
          when 233 #> Dragon Call
            if ::GameData::Flag_4G
              nb_turn = 1/0.0
            end
            _mp([:ability_display, pkmn])
            _mp([:weather_change, :time, nb_turn])
            # _mp([:global_animation, 494])
          when 118 #> Snow Warning
            if ::GameData::Flag_4G
              nb_turn = 1/0.0
            else
              nb_turn = BattleEngine::_has_item(pkmn, 282) ? 8 : 5 #> Icy Rock
            end
            _mp([:ability_display, pkmn])
            _mp([:weather_change, :hail, nb_turn])
          when 102 #> Anticipation
            skill = nil
            enemies.each do |enemy|
              enemy.skills_set.each do |skill|
                if BattleEngine._type_modifier_calculation(pkmn, skill) >= 2 || 
                  skill.symbol == :s_ohko || 
                  skill.symbol == :s_explosion
                  _mp([:ability_display, pkmn])
                  _msgp(19, 436, pkmn)
                  skill = true
                  break
                end
              end
              break if skill == true
            end
          when 50 #> Forewarn
            skill = nil
            _pkmn = enemies[0]
            _skill = _pkmn.skills_set[0]
            enemies.each do |enemy|
              enemy.skills_set.each do |skill|
                if _skill.power < skill.power
                  _skill = skill
                  _pkmn = enemy
                elsif _skill.power == skill.power && rand(2) == 0
                  _skill = skill
                  _pkmn = enemy
                end
              end
            end
            _msgp(19, 433, _pkmn, BattleEngine::MOVE[1] => _skill.name)
          when 85 #> Frisk
            target = BattleEngine::_random_target_selection(pkmn, nil)
            if(target.item_holding != 0)
              _mp([:ability_display, pkmn])
              _msgp(19, 439, pkmn, PKNICK[1] => target.given_name, ::PFM::Text::ITEM2[2] => target.item_name)
            end
          when 70 #> Download
            target = BattleEngine::_random_target_selection(pkmn, nil)
            _mp([:ability_display, pkmn])
            _mp([target.dfe < target.dfs ? :change_atk : :change_ats, pkmn, 1])
          end
        end
        #> Enemy's abilities check
        enemies.each do |enemy|
          unless enemy.battle_effect.has_no_ability_effect? || enemy.dead? || enemy.battle_effect.nb_of_turn_here > 0
            case enemy.ability
            when 11 #> Intimidate
              _mp([:ability_display, enemy])
              _mp([:change_atk, pkmn, -1])
            end
          end
        end
      end
      #===
      #> Abilities triggered when the weather changes
      #===
      #===
      #> Abilities that heal at the end of the turn
      #===
      #===
      #> Abilitied at the end of the turn
      #===
      #===
      #> Abilities that attrack moves
      #===  
    end
  end
  

  module PFM
    class Environment
      # List of weather symbols
      WEATHER_NAMES = %i[none rain sunny sandstorm hail fog hardsun hardrain wind time]
      # Apply a new weather to the current environment
      # @param id [Integer, Symbol] ID of the weather : 0 = None, 1 = Rain, 2 = Sun/Zenith, 3 = Darud Sandstorm, 4 = Hail, 5 = Foggy
      # @param duration [Integer, nil] the total duration of the weather (battle), nil = never stops
      def apply_weather(id, duration = nil)
        id = WEATHER_NAMES.index(id) || 0 if id.is_a?(Symbol)
        @battle_weather = id
        @weather = id unless @game_state.game_temp.in_battle && !@game_state.game_switches[::Yuki::Sw::MixWeather]
        @duration = (duration || Float::INFINITY)
        ajust_weather_switches
      end
  
      # Return the current weather duration
      # @return [Numeric] can be Float::INFINITY
      def weather_duration
        return @duration
      end
      alias get_weather_duration weather_duration
  
      # Decrease the weather duration, set it to normal (none = 0) if the duration is less than 0
      # @return [Boolean] true = the weather stopped
      # Return the current weather id according to the game state (in battle or not)
      # @return [Integer]
  
      # Return the db_symbol of the current weather
      # @return [Symbol]
  
      # Ancheint Dragon Call
      def time?
        return current_weather_db_symbol == :time
      end
  
      private
  
      # Update the state of each switches so the system knows what happens
      def ajust_weather_switches
        weather = current_weather
        weather_switches.each_with_index do |switch_id, i|
          next if switch_id < 1
  
          @game_state.game_switches[switch_id] = weather == i
        end
        @game_state.game_map.need_refresh = true
      end
  
      # Get the list of switch related to weather
      # @return [Array<Integer>]
      def weather_switches
        sw = Yuki::Sw
        return [-1, sw::WT_Rain, sw::WT_Sunset, sw::WT_Sandstorm, sw::WT_Snow, sw::WT_Fog]
      end
    end
  end


  module BattleEngine
    module BE_Interpreter
      def weather_change(meteo_sym, nb_turn=5)
        case meteo_sym
        when :rain
          $env.apply_weather(1, nb_turn)
          _msgp(18, 88, nil)
        when :sunny
          $env.apply_weather(2, nb_turn)
          _msgp(18, 87, nil)
        when :sandstorm
          $env.apply_weather(3, nb_turn)
          _msgp(18, 89, nil)
        when :hail
          $env.apply_weather(4, nb_turn)
          _msgp(18, 90, nil)
        when :fog
          $env.apply_weather(5, nb_turn)
          _msgp(18, 91, nil)
        when :time
          $env.apply_weather(9, nb_turn)
          _msgp(18, 288, nil)
        else
          $env.apply_weather(0, nb_turn)
        end
        #> Display that the effect will not work
        if($env.current_weather != 0 && BattleEngine.state[:air_lock])
          @scene.ability_display(BattleEngine.state[:air_lock])
          @scene.display_message(parse_text(18,97)) # "The effects of the weather disappeared."
        end
        #> Weather ability
        Abilities.on_weather_change
      end
    end
  end