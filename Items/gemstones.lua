-- Gemstone Consumable Type
SMODS.ConsumableType{
	key = "Gemstone",
    primary_colour = HEX("d1303e"),
    secondary_colour = HEX("d1303e"),
    collection_rows = { 5, 5 },
    shop_rate = 2,
    loc_txt = {
        collection = "Gemstone Cards",
        name = "Gemstone",
        label = "Gemstone",
        undiscovered = {
            name = "Undiscovered Gemstone",
            text = { "Apply this gem", "to a card to", "discover its ability!" },
        }
    },
    default = "gem-Ruby",
    can_stack = true,
    can_divide = true
}

-- Ruby Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Ruby",
    key = "ruby",
    atlas = "gems_atlas",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        x_mult = 1.2,
        sticker_id = "gemslot_ruby"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.x_mult } }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) return can_use_gemstone_consumeable(self, card) end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Pearl Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Pearl",
    key = "pearl",
    atlas = "gems_atlas",
    pos = { x = 1, y = 0 },
    soul_pos = { x = 1, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_pearl"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = {} }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Topaz Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Topaz",
    key = "topaz",
    atlas = "gems_atlas",
    pos = { x = 2, y = 0 },
    soul_pos = { x = 2, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        money_earned = 2,
        sticker_id = "gemslot_topaz"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.money_earned } }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Amber Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Amber",
    key = "amber",
    atlas = "gems_atlas",
    pos = { x = 3, y = 0 },
    soul_pos = { x = 3, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        level_up_odds = 3,
        sticker_id = "gemslot_amber"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = {G.GAME.probabilities.normal or 1, self.config.level_up_odds} }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) return can_use_gemstone_consumeable(self, card) end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Opal Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Opal",
    key = "opal",
    atlas = "gems_atlas",
    pos = { x = 4, y = 0 },
    soul_pos = { x = 4, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        level_up_odds = 3,
        sticker_id = "gemslot_opal"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = {} }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Diamond Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Diamond",
    key = "diamond",
    atlas = "gems_atlas",
    pos = { x = 5, y = 0 },
    soul_pos = { x = 5, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        retriggers = 1,
        sticker_id = "gemslot_diamond"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.retriggers } }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Amethyst Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Amethyst",
    key = "amethyst",
    atlas = "gems_atlas",
    pos = { x = 6, y = 0 },
    soul_pos = { x = 6, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        h_x_mult = 1.35,
        sticker_id = "gemslot_amethyst"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.h_x_mult } }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Aquamarine Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Aquamarine",
    key = "aquamarine",
    atlas = "gems_atlas",
    pos = { x = 7, y = 0 },
    soul_pos = { x = 7, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        x_chips = 2,
        sticker_id = "gemslot_aquamarine"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.x_chips } }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}

-- Jade Gemstone
SMODS.Consumable{
    object_type = "Consumable",
    set = "Gemstone",
    name = "gem-Jade",
    key = "jade",
    atlas = "gems_atlas",
    pos = { x = 8, y = 0 },
    soul_pos = { x = 8, y = 1 },
    cost = 3,
    should_apply = false,
    disovered = true,
    order = 1,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_jade"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = {} }
        return { vars = { self.config.max_highlighted } }
    end,

    can_use = function(self, card) 
        return 
        #G.hand.highlighted == self.config.max_highlighted
        and
        get_gemslot(G.hand.highlighted[1]) ~= nil 
    end,
    use = function(self, card, area, copier) use_gemstone_consumeable(self, card, area, copier, true) end,
}