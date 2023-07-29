Config = {}

Config.Debug = false                    -- If true, adds prints and ignores cop check

Config.MinCops = 2                      -- Minimum cops on duty, TODO
Config.DayChance = 60                   -- Chance to alert cops during the day (out of 100)
Config.NightChance = 20                 -- Chance to alert cops during the night (out of 100)
Config.NearbyPed = true                 -- Require a ped nearby to alert cops? (if true, replaces the Day/Night Chances of alerting)
Config.PedDistance = 40.0               -- Radius to check for nearby ped.
Config.Dispatch = 'cd_dispatch'         -- ps-dispatch or cd_dispatch

Config.ItemNeeded = 'oxycutter'         -- Item for qb-target interaction
Config.ScrapTime = {                    -- Time in seconds to steal scraps
  ['small'] = 30,
  ['medium'] = 45,
  ['large'] = 60,
}

Config.DeleteObj = true                 -- Delete the object after scrapping
Config.DeleteDistance = 50.0            -- Distance to check for deleted objects

Config.EnableFingerprint = true         -- Drop a fingerprint at the scene
Config.FingerprintChance = 80           -- Chance of drop

Config.DispatchCaller = {
    'John',
    'James',
    'Betty',
    'Karen',
    'Mr Singh',
    'Dennis',
    'Frank',
    'Peggy',
    'Mildred',
    'Ethel',
    'Gladys',
    'Kevin',
    'Mohammed',
    'Yusuf',
    'Ming',
    'Mrs Wong',
}

Config.DispatchMsg = {
    'Help, these bastards are stealing again',
    'Filthy thieves stealing all the metal, tell em to get a bloody job!',
    'Grubby mongrels pinching copper, DO SOMETHING!',
    'These idiots are thieving from my building again!',
    'Someone is trying to steal scrap materials using an oxy-cutter',
    'I am on the neighbourhood watch and saw a person stealing scrap materials',
    'I think I saw someone stealing copper piping',
    'Theres a dodgy looking person cutting bits off the building, maybe for scrap metal?',
    'I think I saw someone doing something they shouldnt be',
    'Theres a thief going around the neighbourhood stealing shit',
    'Im the security guard for the area and someones stealing parts from my building',
    'Kids are stealing and using foul language, please stop them',
    'Someone across the road is stealing, I tried to stop them but they told me to piss off'
}

Config.ScrapObjects = {
  [1] = {
    ['name'] = 'prop_aircon_l_01', -- Prop Model Name
    ['size'] = 'large', -- Prop size (for progressbar time)
    ['minRewards'] = 2, --Minimum amount of different rewards
    ['maxRewards'] = 4, --Max amount of different rewards
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 3, ['max'] = 5},
      [2] = {['item'] = 'metalscrap', ['min'] = 6, ['max'] =8},
      [3] = {['item'] = 'copper', ['min'] = 5, ['max'] = 30},
      [4] = {['item'] = 'rubber', ['min'] = 4, ['max'] = 7},
      [5] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 5},
      [6] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    },
  },

  [2] = {
    ['name'] = 'prop_aircon_l_02',
    ['size'] = 'large',
    ['minRewards'] = 2,
    ['maxRewards'] = 4,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 3, ['max'] = 5},
      [2] = {['item'] = 'metalscrap', ['min'] = 6, ['max'] =8},
      [3] = {['item'] = 'copper', ['min'] = 5, ['max'] = 30},
      [4] = {['item'] = 'rubber', ['min'] = 4, ['max'] = 7},
      [5] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 5},
      [6] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    }
  },

  [3] = {
    ['name'] = 'prop_aircon_l_03',
    ['size'] = 'large',
    ['minRewards'] = 2,
    ['maxRewards'] = 4,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 3, ['max'] = 5},
      [2] = {['item'] = 'metalscrap', ['min'] = 6, ['max'] =8},
      [3] = {['item'] = 'copper', ['min'] = 5, ['max'] = 30},
      [4] = {['item'] = 'rubber', ['min'] = 4, ['max'] = 7},
      [5] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 5},
      [6] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    }
  },

  [4] = {
    ['name'] = 'prop_aircon_l_03_dam',
    ['size'] = 'large',
    ['minRewards'] = 2,
    ['maxRewards'] = 4,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 3, ['max'] = 5},
      [2] = {['item'] = 'metalscrap', ['min'] = 6, ['max'] =8},
      [3] = {['item'] = 'copper', ['min'] = 5, ['max'] = 30},
      [4] = {['item'] = 'rubber', ['min'] = 4, ['max'] = 7},
      [5] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 5},
      [6] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    }
  },

  [5] = {
    ['name'] = 'prop_aircon_l_04',
    ['size'] = 'large',
    ['minRewards'] = 2,
    ['maxRewards'] = 4,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 3, ['max'] = 5},
      [2] = {['item'] = 'metalscrap', ['min'] = 6, ['max'] =8},
      [3] = {['item'] = 'copper', ['min'] = 5, ['max'] = 30},
      [4] = {['item'] = 'rubber', ['min'] = 4, ['max'] = 7},
      [5] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 5},
      [6] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    }
  },

  [6] = {
    ['name'] = 'prop_aircon_m_01',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
    },
  },

  [7] = {
    ['name'] = 'prop_aircon_m_02',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
    },
  },

  [8] = {
    ['name'] = 'prop_aircon_m_03',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
    },
  },

  [9] = {
    ['name'] = 'prop_aircon_m_04',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
    },
  },

  [10] = {
    ['name'] = 'prop_aircon_m_05',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
    },
  },

  [11] = {
    ['name'] = 'prop_aircon_m_06',
    ['size'] = 'small',
    ['minRewards'] = 1,
    ['maxRewards'] = 2,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 4, ['max'] = 5},
      [3] = {['item'] = 'copper', ['min'] = 2, ['max'] = 15},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 4},
    },
  },

  [12] = {
    ['name'] = 'prop_cablespool_02',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
      [5] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    },
  },

  [13] = {
    ['name'] = 'prop_cablespool_03',
    ['size'] = 'medium',
    ['minRewards'] = 1,
    ['maxRewards'] = 3,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 5, ['max'] = 6},
      [3] = {['item'] = 'copper', ['min'] = 3, ['max'] = 20},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 5},
      [5] = {['item'] = 'steel', ['min'] = 2, ['max'] = 5},
    },
  },

  [14] = {
    ['name'] = 'prop_cablespool_05',
    ['size'] = 'small',
    ['minRewards'] = 1,
    ['maxRewards'] = 2,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 4, ['max'] = 5},
      [3] = {['item'] = 'copper', ['min'] = 2, ['max'] = 15},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 4},
    },
  },

  [15] = {
    ['name'] = 'prop_cablespool_06',
    ['size'] = 'small',
    ['minRewards'] = 1,
    ['maxRewards'] = 2,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 4, ['max'] = 5},
      [3] = {['item'] = 'copper', ['min'] = 2, ['max'] = 15},
      [4] = {['item'] = 'rubber', ['min'] = 2, ['max'] = 4},
    },
  },

  [16] = {
    ['name'] = 'prop_roofvent_06a',
    ['size'] = 'small',
    ['minRewards'] = 1,
    ['maxRewards'] = 2,
    ['rewards'] = {
      [1] = {['item'] = 'plastic', ['min'] = 1, ['max'] = 2},
      [2] = {['item'] = 'metalscrap', ['min'] = 4, ['max'] = 5},
      [3] = {['item'] = 'aluminum', ['min'] = 2, ['max'] = 15},
      [4] = {['item'] = 'rubber', ['min'] = 1, ['max'] = 3},
    },
  },
}