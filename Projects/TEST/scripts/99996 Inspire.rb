module BattleEngine
    def _State_update
        st = @_State
        @_State[:act_follow_me] = nil
        @_State[:enn_follow_me] = nil
        _State_decrease(:trick_room, 122)
        _State_decrease(:gravity, 124)
        _State_decrease(:act_reflect, 132)
        _State_decrease(:enn_reflect, 133)
        _State_decrease(:act_light_screen, 136)
        _State_decrease(:enn_light_screen, 137)
        _State_decrease(:act_inspire, 293)
        _State_decrease(:enn_inspire, 294)
        _State_decrease(:act_safe_guard, 140)
        _State_decrease(:enn_safe_guard, 141)
        _State_decrease(:act_mist, 144)
        _State_decrease(:enn_mist, 145)
        _State_decrease(:act_tailwind, 148)
        _State_decrease(:enn_tailwind, 149)
        _State_decrease(:act_lucky_chant, 152)
        _State_decrease(:enn_lucky_chant, 153)
        _State_decrease(:act_rainbow, 172)
        _State_decrease(:enn_rainbow, 173)
        _State_decrease(:act_firesea, 176)
        _State_decrease(:enn_firesea, 177)
        _State_decrease(:act_swamp, 180)
        _State_decrease(:enn_swamp, 181)
        _State_decrease(:wonder_room, 185)
        _State_decrease(:magic_room, 187)
    end
    def _State_reset
        @_State = {
        :last_critical_hit => 1, 
        :trick_room => 0, #> Compteur de Distortion
        :klutz => false, #> Etat de maladresse
        :air_lock => false, #> état de Air lock et ciel gris
        :last_type_modifier => 1,
        :act_light_screen => 0, #>Mur lumière
        :enn_light_screen => 0,
        :act_inspire => 0,
        :enn_inspire => 0,
        :act_reflect => 0, #>Protection
        :enn_reflect => 0,
        :act_tailwind => 0, #>Vent arrière
        :enn_tailwind => 0,
        :act_lucky_chant => 0, #>Air Veinard
        :enn_lucky_chant => 0,
        :gravity => 0, #>Compteur de gravité
        :last_skill => nil, #>Dernière attaque (pour Photocopie)
        :knock_off => [], #>Sabotage
        :magic_room => 0, #> Zone Magique
        :wonder_room => 0, #> Zone Étrange
        :act_follow_me => nil, #> Par Ici / Poudre Fureur Actors
        :enn_follow_me => nil, #> Par Ici / Poudre Fureur Ennemis
        :act_spikes => 0, #> Picots coté actors
        :enn_spikes => 0, #> Picots coté ennemis
        :act_toxic_spikes => 0, #> Picots toxiques coté actors
        :enn_toxic_spikes => 0, #> Picots toxiques coté ennemis
        :act_stealth_rock => false, #> Piège de rock act
        :enn_stealth_rock => false, #> Piège de rock enn
        :act_sticky_web => false, #> Toile gluante act
        :enn_sticky_web => false, #> Toile gluante enn
        :act_safe_guard => 0, #> Rune protect
        :enn_safe_guard => 0, #> Rune protect
        :act_mist => 0, #> Rune protect
        :enn_mist => 0, #> Rune protect
    
        :act_rainbow => 0, #> Double la chance de status (A-eau-feu)
        :enn_rainbow => 0, #> Double la chance de status
        :act_swamp => 0, #> Réduit la vitesse par 2 (A-eau-herbe)
        :enn_swamp => 0, #> Réduit la vitesse par 2
        :act_firesea => 0, #> Inflige des dégats tous les tours (1/8)
        :enn_firesea => 0, #> Inflige des dégats tous les tours (1/8)
    
        :happy_hour => false, #> Étrennes
        :launcher_item => 0, #> Objet porté par le lanceur
        :target_item => 0, #>Objet porté par la cible
        :launcher_ability => 0, #>Talent du lanceur
        :target_ability => 0, #>Talent de la cible
        :ext_info => nil, #> Informations supplémentaires pour les attaques
        :none => nil}
    end
    
    SCREENS_SYMBOLS = [[:act_light_screen, :enn_light_screen], [:act_reflect, :enn_reflect],
    [:act_safe_guard, :enn_safe_guard], [:act_mist, :enn_mist], [:act_inspire, :enn_inspire]]


    # @param launcher [PFM::Pokemon] user of the move
    # @param target [PFM::Pokemon] target of the move
    # @param skill [PFM::Skill] move that is currently used
    def s_inspire(launcher, target, skill, msg_push = true)
        return false unless __s_beg_step(launcher, target, skill, msg_push)
        return if launcher != target #> Team & Snatch
        nb_turn = 4
        target = _snatch_check(launcher, skill) #> Actuellement je ne vérifie que le lanceur car je ne sais pas comment ça agit en 2v2 quand c'est pas le lanceur sous saisie :<
        sym = target.position < 0 ? :enn_inspire : :act_inspire
        unless @_State[sym] > 0
            _mp([:msg, parse_text(18, target.position < 0 ? 291 : 292)])
            _mp([:set_state, sym, nb_turn])
        else
            _mp(MSG_Fail)
        end
    end
end

module Battle
  module Effects
    # Effect describing LightScreen
    class Inspire < PositionTiedEffectBase
      # Create a new Pokemon tied effect
      # @param logic [Battle::Logic] logic used to get all the handler in order to allow the effect to work
      # @param bank [Integer] bank where the effect is tied
      # @param position [Integer] position where the effect is tied
      # @param turn_count [Integer] number of turn for the confusion (not including current turn)
      def initialize(logic, bank, position, turn_count = 3)
        super(logic, bank, position)
        self.counter = turn_count
      end

      def on_end_turn_event(logic, scene, battlers)
        battlers.each do |battler|
          if (@bank == battler.bank)
            logic.stat_change_handler.stat_change_with_process(:dfs, 1, battler)
          end
        end
      end 

      # Give the move mod1 mutiplier (before the +2 in the formula)
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @param move [Battle::Move] move
      # @return [Float, Integer] multiplier
      # def mod1_multiplier(user, target, move)
      #   return 1 if @bank != target.bank || move.critical_hit? || user.has_ability?(:infiltrator)
      #   return 1 unless move.special?

      #   return $game_temp.vs_type == 2 ? (2 / 3.0) : 0.5
      # end

      # Get the name of the effect
      # @return [Symbol]
      def name
        :inspire
      end

      # Function called when the effect has been deleted from the effects handler
      def on_delete
        @logic.scene.display_message_and_wait(parse_text(18, message_id + @bank.clamp(0, 1)))
      end

      private

      # ID of the message responsive of telling the end of the effect
      # @return [Integer]
      def message_id
        return 293
      end
    end
  end
end  


module Battle
  class Move
    # Move that adds a field on the bank protecting from physicial or special moves
    class Inspire < Move
      # Function that tests if the user is able to use the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
      # @return [Boolean] if the procedure can continue
      def move_usable_by_user(user, targets)
        return false unless super

        if logic.bank_effects[user.bank].has?(db_symbol)
          show_usage_failure(user)
          return false
        end

        return true
      end

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        turn_count = 4
        logic.bank_effects[user.bank].add(Effects::Inspire.new(logic, user.bank, 0, turn_count))
        scene.display_message_and_wait(parse_text(18, 291 + user.bank.clamp(0, 1)))
      end
    end

    Move.register(:s_inspire, Inspire)
  end
end
