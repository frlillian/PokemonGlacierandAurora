module Battle
  module Effects
    # Implement the Foresight effect
    # Foresight - Odor Sleuth
    class Foresight < PokemonTiedEffectBase
      # Function that computes an overwrite of the type multiplier
      # @param target [PFM::PokemonBattler]
      # @param target_type [Integer] one of the type of the target
      # @param type [Integer] one of the type of the move
      # @param move [Battle::Move]
      # @return [Float, nil] overwriten type multiplier
      def on_single_type_multiplier_overwrite(target, target_type, type, move)
        return if target != @pokemon || target_type != data_type(:ghost).id

        return 1 if type == data_type(:normal).id
        return 1 if type == data_type(:fighting).id

        return nil
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :foresight
      end
    end
  end
end
