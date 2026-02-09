-- Check to see if a Gemstone Consumable can be used
function Gemstones.can_use_gemstone_consumeable(self, card)
    local sticker_info = SMODS.Stickers[self.config.sticker_id]

	if sticker_info.card_compat and sticker_info.joker_compat then
		return (#G.jokers.highlighted + #G.hand.highlighted) == (self.config.max_highlighted or 1) and ((Gemstones.get_gemslot(G.jokers.highlighted[1]) ~= nil or Gemstones.get_gemslot(G.hand.highlighted[1])) ~= nil)
	elseif not sticker_info.card_compat and sticker_info.joker_compat then
		return  #G.jokers.highlighted <= self.config.max_highlighted and Gemstones.get_gemslot(G.jokers.highlighted[1]) ~= nil
	elseif sticker_info.card_compat and not sticker_info.joker_compat then
		return  #G.hand.highlighted == self.config.max_highlighted and Gemstones.get_gemslot(G.hand.highlighted[1]) ~= nil
	end
end

-- Use and consume a Gemstone
function Gemstones.use_gemstone_consumeable(self, card, area, copier)
    if self.set == "Gemstone" then G.GAME.last_used_gemstone = self.key or card.key end
	local sticker_info = SMODS.Stickers[self.config.sticker_id]

    if sticker_info.card_compat then
		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					Gemstones.set_gemslot(highlighted, self.config.sticker_id)
					highlighted:juice_up(0.5, 0.5)

					card:juice_up(0.5, 0.5)
					play_sound('gold_seal', 1.2, 0.4)
					return true
				end
			}))
		end
	end

    if sticker_info.joker_compat then
		for i = 1, #G.jokers.highlighted do
			local highlighted = G.jokers.highlighted[i]
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					Gemstones.set_gemslot(highlighted, self.config.sticker_id)
					highlighted:juice_up(0.5, 0.5)

					card:juice_up(0.5, 0.5)
					play_sound('gold_seal', 1.2, 0.4)
					return true
				end
			}))
		end
	end

    delay(0.6)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); G.jokers:unhighlight_all(); return true end }))
end

-- Apply gemstone
function Gemstones.set_gemslot(card, id)
    local stickers = SMODS.Stickers

    for k, v in pairs(card.ability) do
        if string.find(k, "gemslot") then
            stickers[k]:removed(card)
            card.ability[k] = nil
        end
    end

    stickers[id]:added(card)
    card.ability[id] = true
end

-- Check for gemstone
function Gemstones.get_gemslot(card)
    if not card then return nil end

    for k, v in pairs(card.ability) do
        if string.find(k, "gemslot") then
            return k
        end
    end
end

--- HOOKS ---

-- Add random chance of a Gem Slot
local common_events_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local _card = common_events_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

    if area == G.pack_cards and _card.base.id then
		if pseudorandom(pseudoseed("booster_gemstone")) < 1/10 then --Or should it be SMODS.pseudorandom_probability({}, "booster_gemstone", 1, 10, "booster_gemstone")? Was this meant to be affected by oops? Assuming not for the moment; may revert later.
			Gemstones.set_gemslot(_card, pseudorandom_element(Gemstones.pools.cards, pseudoseed("booster_gemstone")))
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.5,
				func = function()
					_card:juice_up(0.5, 0.5)
					play_sound('gold_seal', 1.2, 0.4)
					return true
				end
			}))
		end
	end

	return _card
end

-- Apply Crystal Deck to run
local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(self)
	Backapply_to_runRef(self)

	if self.effect.config.gems_set_slot then
		G.E_MANAGER:add_event(Event({
			func = function()
				for i = #G.playing_cards, 1, -1 do
					Gemstones.set_gemslot(G.playing_cards[i], self.effect.config.sticker_id)
				end

				return true
			end
		}))
	end
end

-- Last used Gemstone card
SMODS.current_mod.reset_game_globals = function(init)
	if init then
		G.GAME.last_used_gemstone = nil
	end
end

-- Localization colors
local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end

	for k, v in pairs(SMODS.Stickers) do
		local sticker = SMODS.Stickers[k]
		G.ARGS.LOC_COLOURS[string.gsub(sticker.key, "gemslot_", "")] = sticker.badge_colour
	end
	return lc(_c, _default)
end

-- Card debuff for Sapphire
SMODS.current_mod.set_debuff = function (card)
  if card.ability.gemslot_sapphire then
     return "prevent_debuff"
  end
end

-- Override Talisman function
function Card:get_chip_x_bonus()
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if ((self.ability.x_chips or 0) + (self.ability.perma_x_chips or 0)) <= 1 then return 0 end
    return self.ability.x_chips + (self.ability.perma_x_chips or 0)
end

-- Card suit for Sapphire
local smodsanysuit = SMODS.has_any_suit
SMODS.has_any_suit = function (card)
	if card.ability.gemslot_sapphire then return true end
	if smodsanysuit(card) then return true end
end

-- Spawn same rarity Joker for Obsidian
local Cardremove = Card.remove
function Card:remove()
	if G.STAGE == G.STAGES.RUN and not G.SETTINGS.paused and self.ability.gemslot_obsidian then
		local legendary = self.config.center.rarity == 4
		local rarity

		if self.config.center.rarity == 1 then
			rarity = 0.5
		elseif self.config.center.rarity == 2 then
			rarity = 0.8
		elseif self.config.center.rarity == 3 then
			rarity = 0.995
		elseif self.config.center.rarity == 4 then
			rarity = 1
		else
			rarity = self.config.center.rarity
		end

		local new_card = SMODS.create_card({
			set = 'Joker',
			area = G.jokers,
			rarity = rarity,
			legendary = legendary
		})
		G.jokers:emplace(new_card)
		new_card:add_to_deck()
	end
	return Cardremove(self)
end

-- Extend SMODS.eval_this
local SMODSeval_this = SMODS.eval_this
function SMODS.eval_this(_card, effects)
	SMODSeval_this(_card, effects)

	if effects then
		local extras = { mult = false, hand_chips = false }
		if effects.Xchip_mod then
            hand_chips = mod_chips(hand_chips * effects.Xchip_mod); extras.hand_chips = true
        end
		update_hand_text({ delay = 0 }, { chips = extras.hand_chips and hand_chips, mult = extras.mult and mult })
	end
end

--- GLOBAL FUNCS ---

-- Check to see if a Gemstone card can be stored
function can_store_gemstone_card(card)
	local limit = 0
	for i = 1, #G.consumeables.cards do
		local card = G.consumeables.cards[i]
		if card.ability.set == "Gemstone" then limit = limit + 0.5 else limit = limit + 1 end
	end

	if limit < G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then return true else return false end
end

-- Deep Clean table
function deep_clean(obj, seen)
	if type(obj) ~= "table" then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do
		res[deep_clean(k, s)] = deep_clean(v, s)
	end
	return res
end

-- Increase Joker Values by X% (from Betmma's Jokers)
function inc_joker_value(self, multi, reset)
    G.E_MANAGER:add_event(Event({func = function()
		if self.default_vals and reset then self.ability = deep_clean(self.default_vals) return true elseif not self.default_vals then self.default_vals = deep_clean(self.ability) end

        local possibleKeys={'bonus','h_mult','mult','t_mult','h_dollars','x_mult','x_chips','extra_value','h_size','perma_bonus','p_dollars','h_x_mult','t_chips','d_size'}
        local self_ability=self.ability

        for k, v in pairs(possibleKeys) do
            if self_ability[v] then
				if (v == "x_chips" or v == "x_mult" or v == "h_x_mult") and self_ability[v] > 1 then
					self_ability[v]=self_ability[v]*multi
				elseif not (v == "x_chips" or v == "x_mult" or v == "h_x_mult") and self_ability[v] ~= 0 then
					self_ability[v]=self_ability[v]*multi
				end

            end
        end
        if self_ability.extra then
            if type(self_ability.extra)=='table' then
                for k, v in pairs(self_ability.extra) do
                    if type(v)=='number' then
                        self_ability.extra[k]=self_ability.extra[k]*multi
                    end
                end
            elseif type(self_ability.extra)=='number' then
                self_ability.extra=self_ability.extra*multi
            end
        end
        self:juice_up(0.5, 0.5)
    return true end }))
    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED, no_juice = true})
end

-- Makes sure Gemstones can be bought with half a slot remaining
local G_FUNCS_check_for_buy_space = G.FUNCS.check_for_buy_space
function G.FUNCS.check_for_buy_space(card)
	if card.ability.consumeable then
		return can_store_gemstone_card(card)
	end

	return G_FUNCS_check_for_buy_space(card)
end

-- Adds a Store button (from Betmma's Vouchers)
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then
		if card.ability.set == "Gemstone" then
			return {
				n = G.UIT.ROOT,
				config = { padding = -0.1, colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							minh = 0.7 * card.T.h,
							maxw = 0.7 * card.T.w - 0.15,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = "use_card",
							func = "can_reserve_card",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("b_pull"),
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.55,
									shadow = true,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							maxw = 0.9 * card.T.w - 0.15,
							minh = 0.1 * card.T.h,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = "Do you know that this parameter does nothing?",
							func = "can_use_consumeable",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("b_use"),
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.45,
									shadow = true,
								},
							},
						},
					},
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					-- Betmma can't explain it, neither can I
				},
			}
		end
	end
	return G_UIDEF_use_and_sell_buttons_ref(card)
end

-- Create UI for Gem Slots
function create_UIBox_gemslots()
	local _pool = {}
	for i, v in pairs(SMODS.Stickers) do
		if i:find("gemslot") then
			_pool[i] = v
		end
	end

	return SMODS.card_collection_UIBox(_pool, { 5, 5 }, {
		snap_back = true,
        hide_single_page = true,
        collapse_single_page = true,
        center = 'c_base',
        h_mod = 1.03,
		back_func = 'your_collection_other_gameobjects',
		modify_card = function(card, center)
            card.ignore_pinned = true
            center:apply(card, true)
        end,
	})
end

-- GLOBALS --

G.FUNCS.can_reserve_card = function(e)
	local limit = 0
	for i = 1, #G.consumeables.cards do
		local card = G.consumeables.cards[i]
		if card.ability.set == "Gemstone" then limit = limit + 0.5 else limit = limit + 1 end
	end

	if limit < G.consumeables.config.card_limit then
		e.config.colour = G.C.GREEN
		e.config.button = "reserve_card"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.reserve_card = function(e)
	local c1 = e.config.ref_table
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then
				c1.children.price:remove()
			end
			c1.children.price = nil
			if c1.children.buy_button then
				c1.children.buy_button:remove()
			end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.consumeables:emplace(c1)
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end,
	}))
end

-- For Gem Slot collection UI
G.FUNCS.your_collection_gemslot = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
	  definition = create_UIBox_gemslots(),
	}
end

--- SMODS ---

-- Override function to remove Gem Slots from the pool
create_UIBox_your_collection_stickers = function()
	local _pool = {}
	for i, v in pairs(SMODS.Stickers) do
		if not i:find("gemslot") then
			_pool[i] = v
		end
	end

    return SMODS.card_collection_UIBox(_pool, {5,5}, {
        snap_back = true,
        hide_single_page = true,
        collapse_single_page = true,
        center = 'c_base',
        h_mod = 1.03,
        back_func = 'your_collection_other_gameobjects',
        modify_card = function(card, center)
            card.ignore_pinned = true
            center:apply(card, true)
        end,
    })
end

-- Gem Slots Collection Tab
Gemstones.custom_collection_tabs = function()
    return {
        UIBox_button({
			button = 'your_collection_gemslot',
			label = {'Gem Slots'},
			minw = 5,
			minh = 1,
			id = 'your_collection_gemslot',
			focus_args = {snap_to = true}
		})
    }
end

-- Credits Tab
Gemstones.extra_tabs = function()
    local scale = 0.5
    return {
        label = "Credits",
        tab_definition_function = function()
        return {
            n = G.UIT.ROOT,
            config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
            },
            nodes = {
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Lead Developer: Halo",
                    shadow = true,
                    scale = scale,
                    colour = G.C.GOLD
                    }
                }
                }
            },
			{
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Contributors: AlexZGreat, Dragokillfist",
                    shadow = true,
                    scale = scale*0.8,
                    colour = G.C.GREEN
                    }
                }
                }
            },
			{
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Special Thanks: Balatro Modding Community",
                    shadow = false,
                    scale = scale*0.65,
                    colour = G.C.BLACK
                    }
                }
                }
            },
            }
        }
        end
    }
end

-- Config Tab
Gemstones.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        create_toggle({
            label = "Enable Blinds",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Blinds",
        }),
        create_toggle({
            label = "Enable Challenges",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Challenges",
        }),
        create_toggle({
            label = "Enable Decks",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Decks",
        }),
        create_toggle({
            label = "Enable Jokers",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Jokers",
        }),
        create_toggle({
            label = "Enable Tags",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Tags",
        }),
        create_toggle({
            label = "Enable Vouchers",
            ref_table = Gemstones_Config,
            ref_value = "Gems_Vouchers",
        }),
		{
			n = G.UIT.R,
			config = {
			padding = 0,
			align = "cm"
			},
			nodes = {
			{
				n = G.UIT.T,
				config = {
				text = "(Restart your game to apply any changes)",
				shadow = false,
				scale = 0.5*0.5,
				colour = G.C.WHITE
				}
			}
			}
		},
      },
    }
end