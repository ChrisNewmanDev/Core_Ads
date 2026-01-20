window.addEventListener("message", function (event) {
    if (event.data.action === "showAd") {
        const container = document.getElementById("adContainer");
        const logo = document.getElementById("bizLogo");
        const label = document.getElementById("bizLabel");
        const msg = document.getElementById("bizMessage");
        const timer = document.getElementById("bizTimer");

        logo.src = `images/${event.data.logo}`;
        label.innerText = event.data.label;
        msg.innerText = event.data.message;
        timer.style.width = "100%";

        container.style.display = "flex";

        let duration = event.data.duration || 8000;
        let startTime = Date.now();

        const interval = setInterval(() => {
            let elapsed = Date.now() - startTime;
            let percent = Math.max(0, 100 - (elapsed / duration) * 100);
            timer.style.width = percent + "%";

            if (elapsed >= duration) {
                clearInterval(interval);
                container.style.display = "none";
            }
        }, 50);
    }
});
