if not Gemstones_Config.Gems_Tags then return end

-- Create Atlas
SMODS.Atlas{
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34
}

-- Gemstone Tag
SMODS.Tag{
    name = "gems-Gemstone",
    key = "gemstone",
    atlas = "tags",
    pos = { x = 0, y = 0 },
    min_ante = 1,

    apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep('+', G.C.SECONDARY_SET.Spectral,function() 
                local key = 'p_gems_gemstone_mega_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2, G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
		end
	end,
}

-- Infused Tag
SMODS.Tag{
    name = "gems-Infused",
    key = "infused",
    atlas = "tags",
    pos = { x = 1, y = 0 },
    min_ante = 2,

    loc_vars = function(self, info_queue, tag)
        if tag.ability.slot_applied then
            local vars = {}
            if SMODS.Stickers[tag.ability.slot_applied].loc_vars then
                vars = SMODS.Stickers[tag.ability.slot_applied]:loc_vars().vars
            end
            info_queue[#info_queue + 1] = { key = tag.ability.slot_applied, set = "Other", vars = vars } 
        end

        return { vars = { tag.ability.slot_applied and G.localization.descriptions.Other[tag.ability.slot_applied].name or "[gemstone]", 
        colours = { G.ARGS.LOC_COLOURS[tag.ability.slot_applied and tag.ability.slot_applied:gsub("gemslot_", "") or "hearts"] } } }
    end,
    set_ability = function(self, tag)
        tag.ability.slot_applied = pseudorandom_element(Gemstones.pools.jokers, pseudoseed("gems_infused_tag"))
    end,
    apply = function(self, tag, context)
        if context.type == "store_joker_modify" then
            if context.card.ability.set == 'Joker' and not Gemstones.get_gemslot(context.card) and not context.card.temp_slot then
                context.card.temp_slot = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    Gemstones.set_gemslot(context.card, tag.ability.slot_applied)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_slot = nil
                    context.card:juice_up(0.4, 0.4)
                    return true
                end)
                tag.triggered = true
            end
        end
    end
}