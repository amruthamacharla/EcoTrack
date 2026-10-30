// Display the current date
function displayDate() {
    const dateElement = document.getElementById("currentDate");

    if (dateElement) {
        const today = new Date();

        dateElement.textContent = today.toLocaleDateString("en-IN", {
            day: "numeric",
            month: "long",
            year: "numeric"
        });
    }
}

// Display a message when a feature card is clicked
function showFeatureMessage(featureName) {
    alert(featureName + " feature selected! Explore EcoTrack to learn more.");
}

// jQuery functionality
$(document).ready(function () {

    // Display the current date
    displayDate();

    // Add a small animation when a card is clicked
    $(".feature-card").on("click", function () {
        $(this).css("border-color", "#16a34a");

        setTimeout(() => {
            $(this).css("border-color", "#dcfce7");
        }, 500);
    });

    console.log("EcoTrack is ready!");
});