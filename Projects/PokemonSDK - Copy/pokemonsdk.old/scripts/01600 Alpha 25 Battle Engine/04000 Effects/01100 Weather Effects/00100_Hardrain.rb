module Battle
  module Effects
    class Weather
      class Hardrain < Weather
        # Function called at the end of a turn
        # @param logic [Battle::Logic] logic of the battle
        # @param scene [Battle::Scene] battle scene
        # @param battlers [Array<PFM::PokemonBattler>] all alive battlers
        def on_end_turn_event(logic, scene, battlers)
          if $env.decrease_weather_duration
            scene.display_message_and_wait(parse_text(18, 270))
            logic.weather_change_handler.weather_change(:none, 0)
          else
            scene.visual.show_rmxp_animation(battlers.first || logic.battler(0, 0), 493)
          end
        end
      end
      register(:hardrain, Hardrain)
    end
  end
end