module Battle
  module Effects
    class Ability
      class Sturdy < Ability
        # Function called when a damage_prevention is checked
        # @param handler [Battle::Logic::DamageHandler]
        # @param hp [Integer] number of hp (damage) dealt
        # @param target [PFM::PokemonBattler]
        # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
        # @param skill [Battle::Move, nil] Potential move used
        # @return [:prevent, Integer, nil] :prevent if the damage cannot be applied, Integer if the hp variable should be updated
        def on_damage_prevention(handler, hp, target, launcher, skill)
          return if target != @target || hp < target.hp || target.hp != target.max_hp || target == launcher
          return unless launcher&.can_be_lowered_or_canceled?

          handler.scene.visual.show_ability(target)
          return target.hp - 1
        end
      end
      register(:sturdy, Sturdy)
    end
  end
end
