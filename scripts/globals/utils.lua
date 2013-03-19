
utils = {};

function utils.clamp(input, min_val, max_val)
    if input < min_val then
        input = min_val;
    elseif input > max_val then
        input = max_val;
    end
    return input;
end;

function utils.stoneskin(target, dmg)
    --handling stoneskin
    skin = target:getMod(MOD_STONESKIN);
    if(skin > 0) then
        if(skin > dmg) then --absorb all damage
            target:delMod(MOD_STONESKIN,dmg);
            return 0;
        else --absorbs some damage then wear
            target:delStatusEffect(EFFECT_STONESKIN);
            return dmg - skin;
        end
    end

    return dmg;
end;

function utils.takeShadows(target, dmg, shadowbehav)
    if(shadowbehav == nil) then
        shadowbehav = 1;
    end

    local targShadows = target:getMod(MOD_UTSUSEMI);
    local shadowType = MOD_UTSUSEMI;

    if(targShadows == 0) then --try blink, as utsusemi always overwrites blink this is okay
        targShadows = target:getMod(MOD_BLINK);
        shadowType = MOD_BLINK;
    end

    if(targShadows > 0) then
    --Blink has a VERY high chance of blocking tp moves, so im assuming its 100% because its easier!

        if(targShadows >= shadowbehav) then --no damage, just suck the shadows

            local shadowsLeft = targShadows - shadowbehav;

            target:setMod(shadowType, shadowsLeft);

            if(shadowsLeft > 0 and shadowType == MOD_UTSUSEMI) then --update icon
                effect = target:getStatusEffect(EFFECT_COPY_IMAGE);
                if(effect ~= nil) then
                    if(shadowsLeft == 1) then
                        effect:setIcon(EFFECT_COPY_IMAGE);
                    elseif(shadowsLeft == 2) then
                        effect:setIcon(EFFECT_COPY_IMAGE_2);
                    elseif(shadowsLeft == 3) then
                        effect:setIcon(EFFECT_COPY_IMAGE_3);
                    end
                end
            end
            -- remove icon
            if(shadowsLeft <= 0) then
                target:delStatusEffect(EFFECT_COPY_IMAGE);
                target:delStatusEffect(EFFECT_BLINK);
            end

            return 0;
        else --less shadows than this move will take, remove all and factor damage down
            target:delStatusEffect(EFFECT_COPY_IMAGE);
            target:delStatusEffect(EFFECT_BLINK);
            return dmg * ((shadowbehav-targShadows)/shadowbehav);
        end
    end

    return dmg;
end;

function utils.dmgTaken(target, dmg)
    local resist = 1;

    resist = 1+(math.floor((target:getMod(MOD_DMG)/100)*256)/256);

    if(resist < 0.5) then
        resist = 0.5;
    end

    return dmg * resist;
end;

function utils.breathTaken(target, breathDmg)

    local resist = 1+((target:getMod(MOD_DMGBREATH) / 100)*256)/256;

    if(resist < 0.5) then
        resist = 0.5;
    end

    return breathDmg * resist;
end;

function utils.magicTaken(target, magicDmg)

    local resist = ((256 + target:getMod(MOD_DMGMAGIC))/256);

    if(resist < 0.5) then
        resist = 0.5;
    end

    return magicDmg * resist;
end;

function utils.physicalTaken(target, dmg)

    local resist = 1+((target:getMod(MOD_DMGPHYS) / 100)*256)/256;

    if(resist < 0.5) then
        resist = 0.5;
    end

    return dmg * resist;
end;

function utils.rangedTaken(target, dmg)
    local resist = 1+((target:getMod(MOD_DMGRANGE) / 100)*256)/256;

    if(resist < 0.5) then
        resist = 0.5;
    end

    return dmg * resist;
end;