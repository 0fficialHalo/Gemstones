if not Gemstones_Config.Gems_Jokers then return end

-- Create Atlas
SMODS.Atlas{
    key = "joker",
    path = "jokers.png",
    px = 71,
    py = 95
}

-- Drill Miner
SMODS.Joker{
    object_type = "Joker",
    name = "gems-Drill Miner",
    key = "drill_miner",
    atlas = "joker",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    order = 1,
    blueprint_compat = true,
    config = {},

    loc_vars = function(self, info_queue, desc_nodes)
        return {}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            local limit = 0
	        for i = 1, #G.consumeables.cards do
	        	local card = G.consumeables.cards[i]
	        	if card.ability.set == "Gemstone" then limit = limit + 0.5 else limit = limit + 1 end
	        end

            if limit < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    delay = 0.5,
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Gemstone',G.consumeables, nil, nil, nil, nil, nil, 'drill_miner')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))   
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_gemstone'), colour = G.C.PURPLE})                       
                            return true
                        end)
                    })
                )
            end
        end
    end
}

-- Gem Gauntlet
SMODS.Joker{
    object_type = "Joker",
    name = "gems-Gem Gauntlet",
    key = "gem_gauntlet",
    atlas = "joker",
    pos = { x = 1, y = 0 },
    rarity = 2,
    cost = 7,
    order = 2,
    blueprint_compat = true,
    config = {
        gem_slot_tally = 0,
        extra = { xmod_increase = 0.1 }
    },

    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.xmod_increase, 1 + (center.ability.extra.xmod_increase * center.ability.gem_slot_tally) } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.gem_slot_tally > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={1 + (card.ability.extra.xmod_increase * card.ability.gem_slot_tally)}},
                    Xmult_mod = 1 + (card.ability.extra.xmod_increase * card.ability.gem_slot_tally), 
                    colour = G.C.MULT
                }
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.gem_slot_tally = 0

        if G["playing_cards"] and G["jokers"] then
            for i = 1, #G.playing_cards do
                local c = G.playing_cards[i]
                for k, v in pairs(c.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" then
                    card.ability.gem_slot_tally = card.ability.gem_slot_tally + 1
                end end
            end
    
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                for k, v in pairs(j.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" then
                    card.ability.gem_slot_tally = card.ability.gem_slot_tally + 1
                end end
            end
        end
    end,

    update = function(self, card, context)
        card.ability.gem_slot_tally = 0
        
        if G["playing_cards"] and G["jokers"] then
            for i = 1, #G.playing_cards do
                local c = G.playing_cards[i]
                for k, v in pairs(c.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" then
                    card.ability.gem_slot_tally = card.ability.gem_slot_tally + 1
                end end
            end
    
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                for k, v in pairs(j.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" then
                    card.ability.gem_slot_tally = card.ability.gem_slot_tally + 1
                end end
            end
        end
    end
}

-- Blacksmith
SMODS.Joker{
    object_type = "Joker",
    name = "gems-Blacksmith",
    key = "blacksmith",
    atlas = "joker",
    pos = { x = 2, y = 0 },
    rarity = 1,
    cost = 4,
    order = 3,
    blueprint_compat = false,
    config = {},

    loc_vars = function(self, info_queue, desc_nodes)
        info_queue[#info_queue + 1] = { key = "gemslot_empty", set = "Other", vars = {} }
        return {}
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)

        elseif context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            local _card = context.full_hand[1]
            if not Gemstones.get_gemslot(_card) then
                Gemstones.set_gemslot(_card, "gemslot_empty")
                
                _card:juice_up(0.5, 0.5)
                play_sound('gold_seal', 1.2, 0.4)

                return {
                    message = localize('k_applied_ex'),
                    colour = G.C.CHIPS,
                    card = card,
                }
            end
        end
    end
}

-- Domini
SMODS.Joker{
    object_type = "Joker",
    name = "gems-Domini",
    key = "domini",
    atlas = "joker",
    pos = { x = 3, y = 0 },
    soul_pos = { x = 3, y = 1 },
    rarity = 4,
    cost = 20,
    order = 4,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = false,
    rental_compat = false,
    config = {
        gemstone_tally = 0,
        extra = { unique_count = 2 }
    },

    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.unique_count, math.floor(center.ability.gemstone_tally / center.ability.extra.unique_count) } }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.gemstone_tally = 0
        local found = {}
        
        if G["playing_cards"] and G["jokers"] then
            for i = 1, #G.playing_cards do
                local c = G.playing_cards[i]
                for k, v in pairs(c.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" and not found[k] then
                    found[k] = true
                    card.ability.gemstone_tally = card.ability.gemstone_tally + 1
                end end
            end
    
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                for k, v in pairs(j.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" and not found[k] then
                    found[k] = true
                    card.ability.gemstone_tally = card.ability.gemstone_tally + 1
                end end
            end
        end
    end,

    update = function(self, card, context)
        card.ability.gemstone_tally = 0
        local found = {}
        
        if G["playing_cards"] and G["jokers"] then
            for i = 1, #G.playing_cards do
                local c = G.playing_cards[i]
                for k, v in pairs(c.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" and not found[k] then
                    found[k] = true
                    card.ability.gemstone_tally = card.ability.gemstone_tally + 1
                end end
            end
    
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                for k, v in pairs(j.ability) do if string.find(k, "gemslot") and k ~= "gemslot_empty" and not found[k] then
                    found[k] = true
                    card.ability.gemstone_tally = card.ability.gemstone_tally + 1
                end end
            end
        end
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and card.ability.gemstone_tally > 1 then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.gemstone_tally / card.ability.extra.unique_count,
                card = card
            }
        end
    end
}