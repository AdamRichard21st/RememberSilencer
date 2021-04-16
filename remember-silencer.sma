#include < amxmodx >
#include < cstrike >
#include < fakemeta >
#include < hamsandwich >


// whenever user has silencer attached to the weapon
public bool:bSilent[33][CSW_M4A1 + 1];



public plugin_init()
{
    register_plugin("Remember Silencer", "1.0.0", "AdamRichard21st");

    // listen to when m4/usp gets added to player inventory
    RegisterHam(Ham_Item_AddToPlayer, "weapon_m4a1", "CBasePlayer_AddToPlayer", .Post = true);
    RegisterHam(Ham_Item_AddToPlayer, "weapon_usp", "CBasePlayer_AddToPlayer", .Post = true);

    // listen to when m4/usp secondary function is triggered
    RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_m4a1", "CBasePlayerWeapon_SecondaryAttack", .Post = true);
    RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_usp", "CBasePlayerWeapon_SecondaryAttack", .Post = true);
}


public client_putinserver(id)
{
    // resets user silencer preferences
    bSilent[id][CSW_M4A1] = false;
    bSilent[id][CSW_USP] = false;
}


// callback called whenever m4/usp is added to player inventory
public CBasePlayer_AddToPlayer(this, id)
{
    // checks if weapon entity is valid and player is connected
    if ( pev_valid(this) == 2 && is_user_alive(id) )
    {
        // gets the weapon csw id
        new m_iId = cs_get_weapon_id(this);

        // checks if silencer should be added back to weapon
        if ( bSilent[id][m_iId] )
        {
            // adds the silencer back to weapon
            cs_set_weapon_silen(this);
        }
    }
}


// callback called whenever m4/usp secondary attack is triggered
public CBasePlayerWeapon_SecondaryAttack(this)
{
    // checks if weapon entity is valid
    if ( pev_valid(this) == 2 )
    {
        // gets the player carrying the weapon
        new id = pev(this, pev_owner);

        // not too late to verifiy if player is valid
        if ( is_user_alive(id) )
        {
            // gets the weapon csw id
            new m_iId = cs_get_weapon_id(this);

            // saves if weapon has silent attached
            bSilent[id][m_iId] = cs_get_weapon_silen(this) != 0;
        }
    }
}