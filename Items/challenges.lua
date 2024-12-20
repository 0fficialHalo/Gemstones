-- Amber Gamble
SMODS.Challenge{
    key = "amber_gamble",
    order = 1,
    rules = {
        custom = {
            { id = "gems_no_planets" }
        },
        modifiers = {}
    },
    restrictions = {
		banned_cards = {
            { id = "j_astronomer" },
            { id = "j_space" },
            { id = 'j_certificate' },
            { id = 'j_satellite' } ,
            { id = 'j_constellation' },
            { id = 'j_burnt' },
            { id = 'v_telescope' },
            { id = 'v_observatory' },
            { id = "v_planet_merchant" },
            { id = "v_planet_tycoon" },
            { id = "c_high_priestess" },
            { id = "c_gems_turquoise" },
            { id = "c_gems_shine" },
            { id = "c_black_hole" },
            { id = "c_trance" },
            { id = 'p_celestial_normal_1', ids = {
                'p_celestial_normal_1','p_celestial_normal_2','p_celestial_normal_3','p_celestial_normal_4','p_celestial_jumbo_1','p_celestial_jumbo_2','p_celestial_mega_1','p_celestial_mega_2',
            }},
        },
        banned_tags = {
            { id = "tag_meteor" },
            { id = 'tag_orbital' },
        },
		banned_other = {},
    },
    deck = { type = "Challenge Deck" },
    jokers = {
        { id = 'j_space', eternal = true, edition = 'negative', gemslot = "gemslot_amber" },
    },
    consumeables = {},
    vouchers = {},
}