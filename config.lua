Config = {}

-- Webhook for logging ads
Config.WebhookURL = "webhook_here"

-- Duration ads stay on screen (in milliseconds)
Config.DisplayTime = 6000

--(must be PNGs in html/images/)
-- Whitelisted jobs, logo, label, and minimum grade allowed to advertise.
--TAKE NOTE, I had to remove the appropriate names for shops etc cause of that TOS / copyright stuff.
Config.AllowedAds = {
    ["burgershop"] = {				--Job name.
        label = "Burgershop",		--Display label.
        logo = "burgershop.png",	--Logo name in images folder.
		minGrade = 1				--Minimum job grade you need to be to advertise.
    },
    ["catshop"] = {
        label = "Cat Shop",
        logo = "catshop.png",
		minGrade = 0
    },
	["ambulance"] = {
        label = "EMS",
        logo = "ems.png",
		minGrade = 0
    },
    ["police"] = {
        label = "Police",
        logo = "pd.png",
		minGrade = 0
    },
	["mechanic1"] = {			
        label = "Mechanic Shop 1",
        logo = "mechanic1.png",
		minGrade = 0
    },
    ["pawnshop"] = {
        label = "Pawnshop",
        logo = "pawnshop.png",
		minGrade = 0
    },
}
