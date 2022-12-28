module PFM
  # Environment management (Weather, Zone, etc...)
  #
  # The global Environment object is stored in $env and PFM.game_state.env
  # @author Nuri Yuri
  class Environment
    # Unkonw location text
    UNKNOWN_ZONE = 'Zone ???'
    include GameData::SystemTags
    # The master zone (zone that show the panel like city, unlike house of city)
    # @note Master zone are used inside Pokemon data
    # @return [Integer]
    attr_reader :master_zone
    # Last visited map ID
    # @return [Integer]
    attr_reader :last_map_id
    # Custom markers on worldmap
    # @return [Array]
    attr_reader :worldmap_custom_markers
    # Return the modified worldmap position or nil
    # @return [Array, nil]
    attr_reader :modified_worldmap_position
    # Get the game state responsive of the whole game state
    # @return [PFM::GameState]
    attr_accessor :game_state

    # Create a new Environnement object
    # @param game_state [PFM::GameState] variable responsive of containing the whole game state for easier access
    def initialize(game_state = PFM.game_state)
      @weather = 0
      @battle_weather = 0
      @fterrain = 0
      @battle_fterrain = 0
      @duration = Float::INFINITY
      @ftduration = Float::INFINITY
      # Zone where the player currently is
      @zone = 0
      # Zone where the current zone is a child of
      @master_zone = 0
      @warp_zone = 0
      @last_map_id = 0
      @visited_zone = []
      @visited_worldmap = []
      @deleted_events = {}
      # Worldmap where the player currently is
      @worldmap = 0
      @worldmap_custom_markers = []
      @game_state = game_state
    end

    # Is the player inside a building (and not on a systemtag)
    # @return [Boolean]
    def building?
      return (!@game_state.game_switches[Yuki::Sw::Env_CanFly] && @game_state.game_player.system_tag == 0)
    end

    # Update the zone informations, return the ID of the zone when the player enter in an other zone
    #
    # Add the zone to the visited zone Array if the zone has not been visited yet
    # @return [Integer, false] false = player was in the zone
    def update_zone
      return false if @last_map_id == @game_state.game_map.map_id

      @last_map_id = map_id = @game_state.game_map.map_id
      last_zone = @zone
      # Searching for the current zone
      each_data_zone do |data|
        next unless data

        if data.maps.include?(map_id)
          load_zone_information(data, data.id)
          break
        end
      end
      return false if last_zone == @zone

      return @zone
    end

    # Load the zone information
    # @param data [Studio::Zone] the current zone data
    # @param index [Integer] the index of the zone in the stack
    def load_zone_information(data, index)
      @zone = index
      # We store this zone as the zone where to warp if it's possible
      @warp_zone = index if data.warp.x && data.warp.y
      # We store this zone as the master zone if there's a panel
      @master_zone = index if data.panel_id&.>(0)
      # We memorize the fact we visited this zone
      @visited_zone << index unless @visited_zone.include?(index)
      if data.worldmaps.any?
        # We memorize the fact we visited this worldmap
        @visited_worldmap << data.worldmaps.first unless @visited_worldmap.include?(data.worldmaps.first)
        # We store the zone worldmap
        @worldmap = data.worldmaps.first
      end
      # We store the new switch info
      @game_state.game_switches[Yuki::Sw::Env_CanFly] = (!data.is_warp_disallowed && data.is_fly_allowed)
      @game_state.game_switches[Yuki::Sw::Env_CanDig] = (!data.is_warp_disallowed && !data.is_fly_allowed)
      return unless data.forced_weather

      if data.forced_weather == 0
        @game_state.game_screen.weather(0, 0, @game_state.game_switches[Yuki::Sw::Env_CanFly] ? 40 : 0)
      else
        @game_state.game_screen.weather(0, 9, 40, psdk_weather: data.forced_weather)
      end
    end

    # Reset the zone informations to get the zone id with update_zone (Panel display)
    def reset_zone
      @last_map_id = -1
      @zone = -1
    end

    # Return the current zone in which the player is
    # @return [Integer] the zone ID in the database
    def current_zone
      return @zone
    end
    alias get_current_zone current_zone

    # Return the zone data in which the player is
    # @return [Studio::Zone]
    def current_zone_data
      data_zone(@zone)
    end
    alias get_current_zone_data current_zone_data

    # Return the zone name in which the player is (master zone)
    # @return [String]
    def current_zone_name
      zone = @master_zone
      return data_zone(zone).name if zone

      UNKNOWN_ZONE
    end

    # Return the warp zone ID (where the player will teleport with skills)
    # @return [Integer] the ID of the zone in the database
    def warp_zone
      return @warp_zone
    end
    alias get_warp_zone warp_zone

    # Get the zone data in the worldmap
    # @param x [Integer] the x position of the zone in the World Map
    # @param y [Integer] the y position of the zone in the World Map
    # @param worldmap_id [Integer] <default : @worldmap> the worldmap to refer at
    # @return [Studio::Zone, nil] nil = no zone there
    def get_zone(x, y, worldmap_id = @worldmap)
      zone_id = data_world_map(worldmap_id).grid.dig(y, x)
      return zone_id && zone_id >= 0 ? data_zone(zone_id) : nil
    end

    # Return the zone coordinate in the worldmap
    # @param zone_id [Integer] id of the zone in the database
    # @param worldmap_id [Integer] <default : @worldmap> the worldmap to refer at
    # @return [Array(Integer, Integer)] the x,y coordinates
    def get_zone_pos(zone_id, worldmap_id = @worldmap)
      return 0, 0 unless (zone = data_zone(zone_id))
      return zone.position.x, zone.position.y if zone.position.x && zone.position.y

      # Trying to find the current zone
      world_map = data_world_map(worldmap_id)
      y = world_map.grid.find_index { |row| row.include?(zone_id) }
      return 0, 0 unless y

      x = world_map.grid[y].find_index { |cell| cell == zone_id } || 0
      return x, y
    end

    # Check if a zone has been visited
    # @param zone [Integer, Studio::Zone] the zone id in the database or the zone
    # @return [Boolean]
    def visited_zone?(zone)
      zone = zone.id if zone.is_a?(Studio::Zone)
      return @visited_zone.include?(zone)
    end

    # Get the worldmap from the zone
    # @param zone [Integer] <default : current zone>
    # @return [Integer]
    def get_worldmap(zone = @zone)
      if @modified_worldmap_position && @modified_worldmap_position[2]
        return @modified_worldmap_position[2] || 0
      elsif zone.is_a?(Studio::Zone)
        return Studio::Zone.from(zone).worldmaps.first || 0
      else
        return data_zone(zone).worldmaps.first || 0
      end
    end

    # Test if the given world map has been visited
    # @param worldmap [Integer]
    # @return [Boolean]
    def visited_worldmap?(worldmap)
      return @visited_worldmap.include?(worldmap)
    end

    # Is the player standing in grass ?
    # @return [Boolean]
    def grass?
      return (@game_state.game_switches[Yuki::Sw::Env_CanFly] && @game_state.game_player.system_tag == 0)
    end

    # Is the player standing in tall grass ?
    # @return [Boolean]
    def tall_grass?
      return @game_state.game_player.system_tag == TGrass
    end

    # Is the player standing in taller grass ?
    # @return [Boolean]
    def very_tall_grass?
      return @game_state.game_player.system_tag == TTallGrass
    end

    # Is the player in a cave ?
    # @return [Boolean]
    def cave?
      return @game_state.game_player.system_tag == TCave
    end

    # Is the player on a mount ?
    # @return [Boolean]
    def mount?
      return @game_state.game_player.system_tag == TMount
    end

    # Is the player on sand ?
    # @return [Boolean]
    def sand?
      tag = @game_state.game_player.system_tag
      return (tag == TSand || tag == TWetSand)
    end

    # Is the player on a pond/river ?
    # @return [Boolean]
    def pond? # Etang / Rivière etc...
      return @game_state.game_player.system_tag == TPond
    end

    # Is the player on a sea/ocean ?
    # @return [Boolean]
    def sea?
      return @game_state.game_player.system_tag == TSea
    end

    # Is the player underwater ?
    # @return [Boolean]
    def under_water?
      return @game_state.game_player.system_tag == TUnderWater
    end

    # Is the player on ice ?
    # @return [Boolean]
    def ice?
      return @game_state.game_player.system_tag == TIce
    end

    # Is the player on snow or ice ?
    # @return [Boolean]
    def snow?
      tag = @game_state.game_player.system_tag
      return (tag == TSnow || tag == TIce) # Ice will be the same as snow for skills
    end

    # Return the zone type
    # @param ice_prio [Boolean] when on snow for background, return ice ID if player is on ice
    # @return [Integer] 1 = tall grass, 2 = taller grass, 3 = cave, 4 = mount, 5 = sand, 6 = pond, 7 = sea, 8 = underwater, 9 = snow, 10 = ice, 0 = building
    def get_zone_type(ice_prio = false)
      if tall_grass?
        return 1
      elsif very_tall_grass?
        return 2
      elsif cave?
        return 3
      elsif mount?
        return 4
      elsif sand?
        return 5
      elsif pond?
        return 6
      elsif sea?
        return 7
      elsif under_water?
        return 8
      elsif snow?
        return ((ice_prio && ice?) ? 10 : 9)
      elsif ice?
        return 10
      else
        return 0
      end
    end

    # Convert a system_tag to a zone_type
    # @param system_tag [Integer] the system tag
    # @return [Integer] same as get_zone_type
    def convert_zone_type(system_tag)
      case system_tag
      when TGrass
        return 1
      when TTallGrass
        return 2
      when TCave
        return 3
      when TMount
        return 4
      when TSand
        return 5
      when TPond
        return 6
      when TSea
        return 7
      when TUnderWater
        return 8
      when TSnow
        return 9
      when TIce
        return 10
      else
        return 0
      end
    end

    # Is it night time ?
    # @return [Boolean]
    def night?
      return @game_state.game_switches[::Yuki::Sw::TJN_NightTime]
    end

    # Is it day time ?
    # @return [Boolean]
    def day?
      return @game_state.game_switches[::Yuki::Sw::TJN_DayTime]
    end

    # Is it morning time ?
    # @return [Boolean]
    def morning?
      return @game_state.game_switches[::Yuki::Sw::TJN_MorningTime]
    end

    # Is it sunset time ?
    # @return [Boolean]
    def sunset?
      return @game_state.game_switches[::Yuki::Sw::TJN_SunsetTime]
    end

    # Can the player fish ?
    # @return [Boolean]
    def can_fish?
      tag = @game_state.game_player.front_system_tag
      return (tag == TPond or tag == TSea)
    end

    # Set the delete state of an event
    # @param event_id [Integer] id of the event
    # @param map_id [Integer] id of the map where the event is
    # @param state [Boolean] new delete state of the event
    def set_event_delete_state(event_id, map_id = @game_state.game_map.map_id, state = true)
      deleted_events = @deleted_events = {} unless (deleted_events = @deleted_events)
      deleted_events[map_id] = {} unless deleted_events[map_id]
      deleted_events[map_id][event_id] = state
    end

    # Get the delete state of an event
    # @param event_id [Integer] id of the event
    # @param map_id [Integer] id of the map where the event is
    # @return [Boolean] if the event is deleted
    def get_event_delete_state(event_id, map_id = @game_state.game_map.map_id)
      return false unless (deleted_events = @deleted_events)
      return false unless deleted_events[map_id]
      return deleted_events[map_id][event_id]
    end

    # Add the custom marker to the worldmap
    # @param filename [String] the name of the icon in the interface/worldmap/icons directory
    # @param worldmap_id [Integer] the id of the worldmap
    # @param x [Integer] coord x on the worldmap
    # @param y [Integer] coord y on the wolrdmap
    # @param ox_mode [Symbol, :center] :center (the icon will be centered on the tile center), :base
    # @param oy_mode [Symbol, :center] :center (the icon will be centered on the tile center), :base
    def add_worldmap_custom_icon(filename, worldmap_id, x, y, ox_mode = :center, oy_mode = :center)
      @worldmap_custom_markers ||= []
      @worldmap_custom_markers[worldmap_id] ||= []
      @worldmap_custom_markers[worldmap_id].push [filename, x, y, ox_mode, oy_mode]
    end

    # Remove all custom worldmap icons on the coords
    # @param filename [String] the name of the icon in the interface/worldmap/icons directory
    # @param worldmap_id [Integer] the id of the worldmap
    # @param x [Integer] coord x on the worldmap
    # @param y [Integer] coord y on the wolrdmap
    def remove_worldmap_custom_icon(filename, worldmap_id, x, y)
      return unless @worldmap_custom_markers[worldmap_id]

      @worldmap_custom_markers[worldmap_id].delete_if { |i| i[0] == filename && i[1] == x && i[2] == y }
    end

    # Overwrite the zone worldmap position
    # @param new_x [Integer] the new x coords on the worldmap
    # @param new_y [Integer] the new y coords on the worldmap
    # @param new_worldmap_id [Integer, nil] the new worldmap id
    def set_worldmap_position(new_x, new_y, new_worldmap_id = nil)
      @modified_worldmap_position = [new_x, new_y, new_worldmap_id]
    end

    # Reset the modified worldmap position
    def reset_worldmap_position
      @modified_worldmap_position = nil
    end
  end

  Environnement = Environment
  class GameState
    # The environment informations
    # @return [PFM::Environment]
    attr_accessor :env

    on_player_initialize(:env) { @env = PFM.environment_class.new(self) }
    on_expand_global_variables(:env) do
      # Variable containing all the environment related information (current zone, weather...)
      $env = @env
      @env.game_state = self
    end
  end
end

PFM.environment_class = PFM::Environment
