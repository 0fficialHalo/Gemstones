-- Create Atlas
SMODS.Atlas{
    key = "gems",
    path = "gemstones.png",
    px = 71,
    py = 95
}

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
Gemstones.GemstoneConsumable{
    name = "gem-Ruby",
    key = "ruby",
    atlas = "gems",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 1 },
    order = 1,
    config = {
        max_highlighted = 1,
        x_mult = 1.25,
        sticker_id = "gemslot_ruby"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.x_mult } }
        return { vars = { self.config.max_highlighted } }
    end,
}

-- Pearl Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Pearl",
    key = "pearl",
    atlas = "gems",
    pos = { x = 1, y = 0 },
    soul_pos = { x = 1, y = 1 },
    order = 2,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_pearl"
    }
}

-- Topaz Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Topaz",
    key = "topaz",
    atlas = "gems",
    pos = { x = 2, y = 0 },
    soul_pos = { x = 2, y = 1 },
    order = 3,
    config = {
        max_highlighted = 1,
        money_earned = 2,
        sticker_id = "gemslot_topaz"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.money_earned } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Amber Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Amber",
    key = "amber",
    atlas = "gems",
    pos = { x = 3, y = 0 },
    soul_pos = { x = 3, y = 1 },
    order = 4,
    config = {
        max_highlighted = 1,
        level_up_odds = 3,
        sticker_id = "gemslot_amber"
    },

    loc_vars = function(self, info_queue)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.level_up_odds, 'gem_amber_desc', false)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { luck, odds } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Opal Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Opal",
    key = "opal",
    atlas = "gems",
    pos = { x = 4, y = 0 },
    soul_pos = { x = 4, y = 1 },
    order = 5,
    config = {
        max_highlighted = 1,
        level_up_odds = 3,
        sticker_id = "gemslot_opal"
    }
}

-- Diamond Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Diamond",
    key = "diamond",
    atlas = "gems",
    pos = { x = 5, y = 0 },
    soul_pos = { x = 5, y = 1 },
    order = 6,
    config = {
        max_highlighted = 1,
        retriggers = 1,
        sticker_id = "gemslot_diamond"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.retriggers } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Amethyst Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Amethyst",
    key = "amethyst",
    atlas = "gems",
    pos = { x = 6, y = 0 },
    soul_pos = { x = 6, y = 1 },
    order = 7,
    config = {
        max_highlighted = 1,
        h_x_mult = 1.35,
        sticker_id = "gemslot_amethyst"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.h_x_mult } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Aquamarine Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Aquamarine",
    key = "aquamarine",
    atlas = "gems",
    pos = { x = 7, y = 0 },
    soul_pos = { x = 7, y = 1 },
    order = 8,
    config = {
        max_highlighted = 1,
        x_chips = 1.75,
        sticker_id = "gemslot_aquamarine"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.x_chips } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Jade Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Jade",
    key = "jade",
    atlas = "gems",
    pos = { x = 8, y = 0 },
    soul_pos = { x = 8, y = 1 },
    order = 9,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_jade"
    }
}

-- Quartz Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Quartz",
    key = "quartz",
    atlas = "gems",
    pos = { x = 9, y = 0 },
    soul_pos = { x = 9, y = 1 },
    order = 10,
    config = {
        max_highlighted = 1,
        bonus_chips = 10,
        sticker_id = "gemslot_quartz"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.bonus_chips } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Emerald Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Emerald",
    key = "emerald",
    atlas = "gems",
    pos = { x = 0, y = 2 },
    soul_pos = { x = 0, y = 3 },
    order = 11,
    config = {
        max_highlighted = 1,
        odds = 4,
        sticker_id = "gemslot_emerald"
    },

    loc_vars = function(self, info_queue)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.odds, 'gem_emerald_desc', false)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { luck, odds } }
        return { vars = { self.config.max_highlighted } }
    end,
}

-- Turquoise Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Turquoise",
    key = "turquoise",
    atlas = "gems",
    pos = { x = 1, y = 2 },
    soul_pos = { x = 1, y = 3 },
    order = 12,
    config = {
        max_highlighted = 1,
        planets_amount = 1,
        sticker_id = "gemslot_turquoise"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.planets_amount } }
        return { vars = { self.config.max_highlighted } }
    end,
}

-- Epidote Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Epidote",
    key = "epidote",
    atlas = "gems",
    pos = { x = 2, y = 2 },
    soul_pos = { x = 2, y = 3 },
    order = 13,
    config = {
        max_highlighted = 1,
        val_multi = 1.1,
        sticker_id = "gemslot_epidote"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { ((self.config.val_multi - 1) * 100) } }
        return { vars = { self.config.max_highlighted } }
    end,
}

-- Adamite Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Adamite",
    key = "adamite",
    atlas = "gems",
    pos = { x = 3, y = 2 },
    soul_pos = { x = 3, y = 3 },
    order = 14,
    config = {
        max_highlighted = 1,
        retriggers = 1,
        chance = 2,
        sticker_id = "gemslot_adamite"
    },

    loc_vars = function(self, info_queue)
        local luck, odds = SMODS.get_probability_vars(self, 1, self.config.chance, 'gem_adamite_desc', false)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { luck, odds, self.config.retriggers } }
        return { vars = { self.config.max_highlighted } }
    end
}

-- Obsidian Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Obsidian",
    key = "obsidian",
    atlas = "gems",
    pos = { x = 4, y = 2 },
    soul_pos = { x = 4, y = 3 },
    order = 15,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_obsidian"
    }
}

-- Sapphire Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Sapphire",
    key = "sapphire",
    atlas = "gems",
    pos = { x = 5, y = 2 },
    soul_pos = { x = 5, y = 3 },
    order = 16,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_sapphire"
    }
}

-- Aventurine Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Aventurine",
    key = "aventurine",
    atlas = "gems",
    pos = { x = 6, y = 2 },
    soul_pos = { x = 6, y = 3 },
    order = 17,
    config = {
        max_highlighted = 1,
        x_mult = 1.75,
        cash = 4,
        sticker_id = "gemslot_aventurine"
    },

    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = self.config.sticker_id, set = "Other", vars = { self.config.x_mult, self.config.cash } }
        return { vars = { self.config.max_highlighted } }
    end
}


-- Time Crystal Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Time Crystal",
    key = "timecrystal",
    atlas = "gems",
    pos = { x = 7, y = 2 },
    soul_pos = { x = 7, y = 3 },
    order = 17,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_timecrystal"
    }
}

-- Time Crystal Gemstone
Gemstones.GemstoneConsumable{
    name = "gem-Citrine",
    key = "citrine",
    atlas = "gems",
    pos = { x = 8, y = 2 },
    soul_pos = { x = 8, y = 3 },
    order = 18,
    config = {
        max_highlighted = 1,
        sticker_id = "gemslot_citrine"
    }
}