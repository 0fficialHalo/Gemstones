-- Create Atlas
SMODS.Atlas{
    key = "slot",
    path = "stickers.png",
    px = 71,
    py = 95
}

-- Empty Gem Slot
Gemstones.GemSlot{
    key = "gemslot_empty",
    badge_colour = HEX("734226"),
    order = 1,
    atlas = "slot",
    pos = { x = 0, y = 0 },
    config = {},
    joker_compat = true,
    card_compat = true
}

-- Ruby Gem Slot
Gemstones.GemSlot{
    key = "gemslot_ruby",
    badge_colour = HEX("e3394f"),
    atlas = "slot",
    pos = { x = 1, y = 0 },
    config = { x_mult = 1.25 },
    joker_compat = true,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.x_mult } }
    end,
    added = function(self, card)
        if card.area ~= G.jokers then card.ability.perma_x_mult = card.ability.perma_x_mult + (self.config.x_mult - 1) end
    end,
    removed = function(self, card)
        if card.area ~= G.jokers then card.ability.perma_x_mult = card.ability.perma_x_mult - (self.config.x_mult - 1) end
    end,
    calculate = function(self, card, context)
        if card.area == G.jokers and context.joker_main then
            return {
                xmult = self.config.x_mult
            }
        end
    end
}

-- Pearl Gem Slot
Gemstones.GemSlot{
    key = "gemslot_pearl",
    badge_colour = HEX("34d2eb"),
    atlas = "slot",
    pos = { x = 2, y = 0 },
    config = {},
    joker_compat = false,
    card_compat = true,
    calculate = function (self, card, context)
        if context.modify_scoring_hand and context.other_card == card then
            return {
                add_to_hand = true
            }
        end
    end
}

-- Topaz Gem Slot
Gemstones.GemSlot{
    key = "gemslot_topaz",
    badge_colour = HEX("e6af19"),
    atlas = "slot",
    pos = { x = 3, y = 0 },
    config = { dollars = 2 },
    joker_compat = true,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.dollars } }
    end,
    added = function(self, card)
        if card.area ~= G.jokers then card.ability.p_dollars = card.ability.p_dollars + self.config.dollars end
    end,
    removed = function(self, card)
        if card.area ~= G.jokers then card.ability.p_dollars = card.ability.p_dollars - self.config.dollars end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.individual and context.other_card == card then
            ease_dollars(self.config.dollars)
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "$"..self.config.dollars, colour = G.C.GOLD})
        end
    end
}

-- Amber Gem Slot
Gemstones.GemSlot{
    key = "gemslot_amber",
    badge_colour = HEX("ff9524"),
    atlas = "slot",
    pos = { x = 4, y = 0 },
    config = { level_up_odds = 3 },
    joker_compat = true,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.level_up_odds, 'gem_amber_desc', false)
        return { vars = { luck, odds } }
    end,
    calculate = function(self, card, context)
            if (
                (context.cardarea == G.play and context.main_scoring)
                or (context.cardarea == G.jokers and context.before)
                )
            and not context.repetition then
                if SMODS.pseudorandom_probability(card, "amber_slot", 1, self.config.level_up_odds, "amber_slot") then
                    return {
                        level_up = true,
                        card = card,
                        message = localize('k_level_up_ex')
                    }
                end
            end
    end
}

-- Opal Gem Slot
Gemstones.GemSlot{
    key = "gemslot_opal",
    badge_colour = HEX("bfeeb0"),
    atlas = "slot",
    pos = { x = 0, y = 1 },
    config = {},
    joker_compat = false,
    card_compat = true,
}

-- Diamond Gem Slot
Gemstones.GemSlot{
    key = "gemslot_diamond",
    badge_colour = HEX("abd8ff"),
    atlas = "slot",
    pos = { x = 1, y = 1 },
    config = { retriggers = 1 },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.retriggers } }
    end,
    calculate = function(self, card, context)
        if context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = self.config.retriggers,
                card = card
            }
        end
    end
}

-- Amethyst Gem Slot
Gemstones.GemSlot{
    key = "gemslot_amethyst",
    badge_colour = HEX("c41ed6"),
    atlas = "slot",
    pos = { x = 2, y = 1 },
    config = { h_x_mult = 1.35 },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.h_x_mult } }
    end,
    added = function(self, card)
        card.ability.perma_h_x_mult = card.ability.perma_h_x_mult + self.config.h_x_mult
    end,
    removed = function(self, card)
        card.ability.perma_h_x_mult = card.ability.perma_h_x_mult - self.config.h_x_mult
    end
}

-- Aquamarine Gem Slot
Gemstones.GemSlot{
    key = "gemslot_aquamarine",
    badge_colour = HEX("80b8c7"),
    atlas = "slot",
    pos = { x = 3, y = 1 },
    config = { x_chips = 1.75 },
    joker_compat = true,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.x_chips } }
    end,
    added = function(self, card)
        if card.area ~= G.jokers then card.ability.perma_x_chips = card.ability.perma_x_chips + self.config.x_chips end
    end,
    removed = function(self, card)
        if card.area ~= G.jokers then card.ability.perma_x_chips = card.ability.perma_x_chips - self.config.x_chips end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.joker_main then
                return { x_chips = self.config.x_chips }
            end
        end
    end
}

-- Jade Gem Slot
Gemstones.GemSlot{
    key = "gemslot_jade",
    badge_colour = HEX("0db813"),
    atlas = "slot",
    pos = { x = 4, y = 1 },
    config = {},
    joker_compat = false,
    card_compat = true,
}

-- Quartz Gem Slot
Gemstones.GemSlot{
    key = "gemslot_quartz",
    badge_colour = HEX("fff3d1"),
    atlas = "slot",
    pos = { x = 0, y = 2 },
    config = { bonus_chips = 10 },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.bonus_chips } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.from_playing_card and not context.repetition then
            card.ability.perma_bonus = (card.ability.perma_bonus or 0) + self.config.bonus_chips
            
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
        end
    end
}

-- Emerald Gem Slot
Gemstones.GemSlot{
    key = "gemslot_emerald",
    badge_colour = HEX("159d49"),
    atlas = "slot",
    pos = { x = 1, y = 2 },
    config = { odds = 4 },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.odds, 'gem_emerald_desc', false)
        return { vars = { luck, odds } }
    end,
    calculate = function(self, card, context)
        if context.discard and (context.other_card == card) then
            local pool = {}
            for i, j in ipairs(G.hand.cards) do
            local _card = G.hand.cards[i]
                if not _card.edition and (_card ~= card) then
                    table.insert(pool, _card)
                end
            end
            if #pool > 0 then
                if SMODS.pseudorandom_probability(card, "gemslot_emerald", 1, self.config.odds, "gemslot_emerald") then
                    local _card = pseudorandom_element(pool, pseudoseed('gemslot_emerald'))
                    local edition = poll_edition('wheel_of_fortune', nil, false, true, {'e_polychrome', 'e_holo', 'e_foil'})
                    _card:set_edition(edition)
                else
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.SECONDARY_SET.Tarot})
                end
            end
        end
    end
}

-- Turquoise Gem Slot
Gemstones.GemSlot{
    key = "gemslot_turquoise",
    badge_colour = HEX("52bab1"),
    atlas = "slot",
    pos = { x = 2, y = 2 },
    config = { planets_amount = 1 },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.planets_amount } }
    end,
    calculate = function(self, card, context)
		if context.destroying_card then
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.0,
				func = function()
					local card_type = "Planet"
					local _planet = nil
					if G.GAME.last_hand_played then
						for k, v in pairs(G.P_CENTER_POOLS.Planet) do
							if v.config.hand_type == G.GAME.last_hand_played then
								_planet = v.key
								break
							end
						end
					end

					for i = 1, self.config.planets_amount do
						local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, "gemslot_turquoise")

						card:set_edition({ negative = true }, true)
						card:add_to_deck()
						G.consumeables:emplace(card)
					end
					return true
				end,
			}))

			return true
		end
	end,
}

-- Epidote Gem Slot
Gemstones.GemSlot{
    key = "gemslot_epidote",
    badge_colour = HEX("7c822b"),
    atlas = "slot",
    pos = { x = 3, y = 2 },
    config = { val_multi = 1.1 },
    joker_compat = true,
    card_compat = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { ((self.config.val_multi - 1) * 100) } }
    end,
    added = function(self, card) card.ability.epidote_upgraded = false end,
    removed = function(self, card) card.ability.epidote_upgraded = nil end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.epidote_upgraded = false
        
        elseif context.end_of_round and context.individual and not context.blueprint and not card.ability.epidote_upgraded then
            card.ability.epidote_upgraded = true
            inc_joker_value(card, self.config.val_multi)
            return nil, true
        end
    end
}

-- Adamite Gem Slot
Gemstones.GemSlot{
    key = "gemslot_adamite",
    badge_colour = HEX("783435"),
    atlas = "slot",
    pos = { x = 4, y = 2 },
    config = { retriggers = 1, chance = 2 },
    joker_compat = true,
    card_compat = false,

    loc_vars = function(self, info_queue, card)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.chance, 'gem_adamite_desc', false)
        return { vars = { luck, odds, self.config.retriggers } }
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == card then
            if SMODS.pseudorandom_probability(card, "adamite_slot", 1, self.config.chance, "adamite_slot") then
			    return {
			    	message = localize("k_again_ex"),
			    	repetitions = self.config.retriggers,
			    	card = card,
			    }
            end
		end
    end
}

-- Obsidian Gem Slot
Gemstones.GemSlot{
    key = "gemslot_obsidian",
    badge_colour = HEX("303a3b"),
    atlas = "slot",
    pos = { x = 0, y = 3 },
    config = {},
    joker_compat = true,
    card_compat = false,
}

-- Sapphire Gem Slot
Gemstones.GemSlot{
    key = "gemslot_sapphire",
    badge_colour = HEX("425fa6"),
    atlas = "slot",
    pos = { x = 1, y = 3 },
    config = {},
    joker_compat = true,
    card_compat = true,

    added = function(self, card) card:set_debuff() end,
    removed = function(self, card) card:set_debuff() end,
}

-- Aventurine Gem Slot
Gemstones.GemSlot{
    key = "gemslot_aventurine",
    badge_colour = HEX("299a74"),
    atlas = "slot",
    pos = { x = 2, y = 3 },
    config = {
        x_mult = 1.75,
        dollars = 4
    },
    joker_compat = false,
    card_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.x_mult, self.config.dollars } }
    end,
    added = function(self, card)
        card.ability.perma_x_mult = card.ability.perma_x_mult + (self.config.x_mult - 1)
        card:flip('back')
    end,
    removed = function(self, card)
        card.ability.perma_x_mult = card.ability.perma_x_mult - (self.config.x_mult - 1)
        card:flip('front')
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            ease_dollars(self.config.dollars)
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "$"..self.config.dollars, colour = G.C.GOLD})
        end
    end
}

-- Time Crystal Gem Slot
Gemstones.GemSlot{
    key = "gemslot_timecrystal",
    badge_colour = HEX("ee75bc"),
    atlas = "slot",
    pos = { x = 3, y = 3 },
    config = {},
    joker_compat = false,
    card_compat = true,
}

-- Citrine Gem Slot
Gemstones.GemSlot{
    key = "gemslot_citrine",
    badge_colour = HEX("c86e04"),
    atlas = "slot",
    pos = { x = 4, y = 3 },
    config = {},
    joker_compat = true,
    card_compat = true,
    calculate = function (self, card, context)
        if context.mod_probability and context.trigger_obj == card and not context.blueprint then
            return {
                numerator = context.numerator + 1
            }
        end
    end
}
