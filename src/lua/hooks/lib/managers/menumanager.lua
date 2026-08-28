---@return table|nil
local function blt_menu_items_mapping()
	local file = io.open(LowAmmoText.mod_path .. "menus/blt_options.json", "r")
	if not file then
		return
	end

	local read = file:read("*all")
	file:close()
	if not read then
		return
	end

	local menu_definition = json.decode(read)
	if not menu_definition then
		return
	end

	local menu_definition_items = menu_definition.items
	if not menu_definition_items then
		return
	end

	local res = {}

	for _, item in pairs(menu_definition_items) do
		if item.id ~= nil and item.value ~= nil then
			res[item.id] = { data_tbl_key = item.value }
		end
	end

	local items = MenuHelper:GetMenu("low_ammo_text_blt_options"):items()
	for _, item in pairs(items) do
		local item_id = item:parameters().name
		local item_definition = res[item_id]
		if item_definition then
			item_definition.menu_item = item
		end
	end

	return res
end

Hooks:Add(
	"MenuManagerSetupCustomMenus",
	"MenuManagerSetupCustomMenus_" .. LowAmmoText.mod_name,
	function(_menu_manager, _nodes)
		LowAmmoText:load_configuration()

		MenuHelper:LoadFromJsonFile(
			LowAmmoText.mod_path .. "menus/blt_options.json",
			LowAmmoText,
			LowAmmoText._data
		)

		-- Add our own callbacks to handle menu value changes
		function MenuCallbackHandler.low_ammo_text__menu_callback__reset_to_default(_self)
			local reset_confirmed = false
			local menu

			local function handle_response()
				if menu then
					menu:Hide()
				end

				if not reset_confirmed then
					return
				end

				LowAmmoText._data = LowAmmoText.tbl.deep_clone(LowAmmoText._default_data)
				LowAmmoText:save_configuration()

				local items_mapping = blt_menu_items_mapping() or {}

				for k, v in pairs(items_mapping) do
					MenuHelper:ResetItemsToDefaultValue(
						v.menu_item,
						{ [k] = true },
						LowAmmoText._data[v.data_tbl_key]
					)
				end
			end

			local menu_title =
				managers.localization:text("low_ammo_text__dialog__reset_to_default__title")
			local menu_desc =
				managers.localization:text("low_ammo_text__dialog__reset_to_default__desc")
			local menu_options = {
				{
					text = managers.localization:text("low_ammo_text__generic__yes"),
					callback = function()
						reset_confirmed = true
						handle_response()
					end,
				},
				{
					text = managers.localization:text("low_ammo_text__generic__no"),
					callback = function()
						reset_confirmed = false
						handle_response()
					end,
				},
			}
			menu = QuickMenu:new(menu_title, menu_desc, menu_options)
			menu:Show()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_font_size(_self, item)
			local val = item:value()

			LowAmmoText._data.text_font_size = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_font_size(val)
			end
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_x(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_x = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_offset_x(val)
			end
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_offset_y(_self, item)
			local val = item:value()

			LowAmmoText._data.text_offset_y = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_offset_y(val)
			end
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_rot_deg(_self, item)
			local val = item:value()

			LowAmmoText._data.text_rot_deg = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_rot_deg(val)
			end
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_alpha(_self, item)
			local val = item:value()

			LowAmmoText._data.text_alpha = val

			if LowAmmoText.ammo_state_manager then
				LowAmmoText.ammo_state_manager:set_alpha(val)
			end
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__text_fade_duration_millis(
			_self,
			item
		)
			LowAmmoText._data.text_fade_duration_millis = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__threshold_low_ammo_clip(
			_self,
			item
		)
			LowAmmoText._data.threshold_low_ammo_clip = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__threshold_low_ammo_total(
			_self,
			item
		)
			LowAmmoText._data.threshold_low_ammo_total = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__pulse_text_animation_start(
			_self,
			item
		)
			LowAmmoText._data.pulse_text_animation_start = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__pulse_text_ease_function_key(
			_self,
			item
		)
			LowAmmoText._data.pulse_text_ease_function_key = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__pulse_text_animation_speed_mul_log(
			_self,
			item
		)
			LowAmmoText._data.pulse_text_animation_speed_mul_log = item:value()
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_no_ammo(_self, item)
			LowAmmoText._data.state_enabled_no_ammo = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_low_total_ammo(
			_self,
			item
		)
			LowAmmoText._data.state_enabled_low_total_ammo = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_clip_empty(
			_self,
			item
		)
			LowAmmoText._data.state_enabled_clip_empty = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_low_ammo_clip(
			_self,
			item
		)
			LowAmmoText._data.state_enabled_low_ammo_clip = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_bulletstorm(
			_self,
			item
		)
			LowAmmoText._data.state_enabled_bulletstorm = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__toggle_state_swan_song_aced(
			_self,
			item
		)
			LowAmmoText._data.state_enabled_swan_song_aced = item:value() == "on"
		end

		function MenuCallbackHandler.low_ammo_text__menu_callback__closed(_self)
			LowAmmoText:save_configuration()
		end
	end
)
