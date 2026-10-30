// MIT License
// Copyright (c) 2026 El Donte - small adaption for Universal Visor (only removed sound here as there's one in main part of UV)
// Copyright (c) 2026 generic name guy - original
// The original file is part of "PB Damage Feedback" (addon)

class UV_HitFeedback_Inventory : Inventory 
{
    /*override void AbsorbDamage(int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        
    }*/

    enum EHPCounters {
        P_CURRENT,
        P_OLD
    };

    int playerArmor[2], playerHealth[2];

    override void DoEffect()
    {
        Super.DoEffect();

        playerArmor[P_CURRENT] = owner.CountInv( "BasicArmor" );
        playerHealth[P_CURRENT] = owner.Health;

        int armorDelta = min( 0, playerArmor[P_OLD] - playerArmor[P_CURRENT] );
        int healthDelta = min( 0, playerHealth[P_OLD] - playerHealth[P_CURRENT] );

        if( playerArmor[P_OLD] > playerArmor[P_CURRENT] && playerArmor[P_CURRENT] <= 0 && playerHealth[P_CURRENT] > 0 )
        {
            EventHandler.SendInterfaceEvent( owner.PlayerNumber(), "UV_hf_ShieldBroken", armorDelta + healthDelta );
//             owner.A_StartSound( "hud/shieldbreak", flags: CHANF_UI ); // Already in UvHudVisorDraw separately
        }

        playerArmor[P_OLD] = playerArmor[P_CURRENT];
        playerHealth[P_OLD] = playerHealth[P_CURRENT];
    }
}

