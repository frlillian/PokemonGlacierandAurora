module Battle
  class Move
    # Move that inflict Hex to the enemy
    class Hex < BasicWithSuccessfulEffect
      # Method calculating the damages done by the actual move
      # @note : I used the 4th Gen formula : https://www.smogon.com/dp/articles/damage_formula
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def damages(user, target)
        hp_dealt = super
        hp_dealt *= 2 if states.include?(Configs.states.symbol(target.status))
        hp_dealt *= 2 if target.has_ability?(:comatose)
        return hp_dealt
      end

      private

      # Return the States that triggers the x2 damages
      STATES = %i[burn paralysis sleep freeze poison toxic]

      # Return the STATES constant
      # @return [Array<Symbol>]
      def states
        STATES
      end
    end
    Move.register(:s_hex, Hex)
  end
end
