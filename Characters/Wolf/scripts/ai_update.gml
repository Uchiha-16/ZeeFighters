target_x_distance = (ai_target.x - x) * spr_dir;
target_y_distance = (y - ai_target.y);

if (get_training_cpu_action() == CPU_FIGHT) {
    //rushdown
    if (!ai_recovering && ai_target.state != PS_RESPAWN && state != PS_PRATFALL) {
        if (abs(target_x_distance) > 100) {
            if ((ai_target.x - x) < 0) {
                left_hard_pressed = true;
                left_down = true;
            } else {
                right_hard_pressed = true;
                right_down = true;
            }
        } else if (can_attack && can_special && (target_within_range(100, 50) || target_within_range(100, -50)) && ai_target.state != PS_RESPAWN) {
            if (free) {
                set_attack(rushdown_air_attacks[random_func(0, array_length(rushdown_air_attacks), true)]);
            } else {
                set_attack(rushdown_ground_attacks[random_func(0, array_length(rushdown_ground_attacks), true)]);
            }
        }
    }
    
    //will jump if enemy on platform above
    if (state == PS_IDLE && !ai_target.free && !target_within_range(100, 20) && target_within_range(100, 200)) {
        jump_pressed = true;
    }
    
    //multishine script
    if ((state == PS_IDLE || state == PS_IDLE_AIR) && state_timer == 0) {
        if (attack == AT_DSPECIAL) {
            
            if (ai_target.state == PS_HITSTUN || ai_target.state == PS_HITSTUN_LAND || ai_target.hitpause) {
                if (get_player_damage(ai_target.player) < 200 && target_within_range(45, 45) == true) {
                    set_attack(AT_DSPECIAL);
                } else if (target_within_range(100, 100) == true) {
                     if !free {
                        
                        if (target_y_distance < 0) {
                            set_attack(AT_DSTRONG);
                        } else {
                            set_attack(AT_USTRONG);
                        }
                        
                    } else {
                        set_attack(AT_USPECIAL);
                    }
                }
            }
        }
    }
    
    //up throw up air
    if (attack == AT_JAB && ai_target.state == PS_HITSTUN) {
        if (state_timer == 0 && !free) {
            if !target_within_range(30, 200) {
                if ((ai_target.x - x) < 0) {
                    left_hard_pressed = true;
                } else {
                    right_hard_pressed = true;
                }
            }
            
            jump_pressed = true;
        }
        if ((state == PS_IDLE_AIR || state == PS_FIRST_JUMP || state == PS_DOUBLE_JUMP) && target_within_range(30, 100)) {
            set_attack(AT_UAIR);
        }
    }
    
    //will always uair when above
    if ((state == PS_IDLE_AIR || state == PS_FIRST_JUMP || state == PS_DOUBLE_JUMP) && target_within_range(30, 100) && (get_player_damage(ai_target.player) > 60)) {
        set_attack(AT_UAIR);
    }
    
    //taunt when dead
    if (!free && can_attack && (ai_target.state == PS_RESPAWN || ai_target.state == PS_DEAD)) {
        set_attack(AT_TAUNT);
    }
    
    //blaster when far away and in air
    if (can_special && !target_within_range(75, 500) && !ai_recovering) {
        if (state == PS_FIRST_JUMP || PS_IDLE_AIR) {
            if (state == PS_FIRST_JUMP && state_timer = 5) {
                set_attack(AT_NSPECIAL);
            }
        } else if (can_jump && !free) {
            jump_pressed = true;
        }
    }
    
}

#define target_within_range

x_range = argument[0];
y_range = argument[1];

if (abs(target_x_distance) <= x_range && target_y_distance <= y_range) {
    return true;
}
return false;