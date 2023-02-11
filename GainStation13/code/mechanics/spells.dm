/obj/effect/proc_holder/spell/targeted/touch/add_weight
	name = "Fattening touch"
	desc = "Channel fattening energy to your hand to fatten people with."
	drawmessage = "You channel fattening energy into your hand."
	dropmessage = "You let the fattening energy from your hand dissipate."
	hand_path = /obj/item/melee/touch_attack/fattening
	charge_max = 400
	clothes_req = FALSE
	action_icon_state = "zap"

/obj/effect/proc_holder/spell/targeted/touch/add_weight/transfer
	name = "Weight transfer"
	hand_path = /obj/item/melee/touch_attack/fattening/transfer

/obj/effect/proc_holder/spell/targeted/touch/add_weight/steal
	name = "Weight steal"
	hand_path = /obj/item/melee/touch_attack/fattening/steal


/obj/item/melee/touch_attack/fattening
	name = "\improper fattening touch"
	desc = "The calories from multiple donuts compressed into pure energy."
	catchphrase = null
	on_use_sound = 'sound/weapons/zapbang.ogg'
	icon_state = "zapper"
	item_state = "zapper"
	///How much weight is added?
	var/weight_to_add = 100
	///What verb is used for the spell?
	var/fattening_verb = "fattens"
	///Is weight being transfered from the user to another mob?

/obj/item/melee/touch_attack/fattening/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || !isliving(target))
		return FALSE
	
	var/mob/living/carbon/gainer = target
	if(!gainer || !weight_to_add)
		return FALSE
	
	if(!gainer.adjust_fatness(weight_to_add, FATTENING_TYPE_MAGIC))
		to_chat(user,"<span class='warning'[target] seems unaffected by [src]</span>")
		return FALSE

	gainer.visible_message("<span class='danger'>[user] [fattening_verb] [target]!</span>","<span class='userdanger'>[user] [fattening_verb] you!</span>")
	return ..()

/obj/item/melee/touch_attack/fattening/transfer
	name = "\improper weight transfer touch"
	desc = "Your weight compressed into a fattening energy."
	fattening_verb = "transfers weight to"

/obj/item/melee/touch_attack/fattening/transfer/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(weight_to_add > user.fatness || !user.adjust_fatness(-weight_to_add, FATTENING_TYPE_MAGIC))
		to_chat(user, "<span class='warning'You don't have enough spare weight to transfer</span>")
		return FALSE

	return ..()

/obj/item/melee/touch_attack/fattening/steal
	name = "\improper weight theft touch"
	desc = "Energy that is eager to take weight."
	fattening_verb = "steals weight from"
	weight_to_add = -100

/obj/item/melee/touch_attack/fattening/steal/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/mob/living/carbon/loser = target
	if(loser.fatness < -weight_to_add)
		to_chat(user, "<span class='warning'[loser] doesn't have enough spare weight to transfer</span>")
		return FALSE

	. = ..()
	if(. != null && !.)
		return FALSE

	user.adjust_fatness(-weight_to_add, FATTENING_TYPE_MAGIC)	

///Spellbooks
/obj/item/book/granter/spell/fattening
	spell = /obj/effect/proc_holder/spell/targeted/touch/add_weight
	spellname = "fattening"
	icon_state ="bookfireball"
	desc = "This book feels warm to the touch."

/obj/item/book/granter/spell/fattening/transfer
	spell = /obj/effect/proc_holder/spell/targeted/touch/add_weight/transfer
	spellname = "weight transfer"
	icon_state ="bookfireball"
	desc = "This book feels warm to the touch."

/obj/item/book/granter/spell/fattening/steal
	spell = /obj/effect/proc_holder/spell/targeted/touch/add_weight/steal
	spellname = "weight steal"
	icon_state ="bookfireball"
	desc = "This book feels warm to the touch."
