// app/javascript/controllers/movie_modal_controller.js
// ou dans app/assets/javascripts/movie_modal.js

document.addEventListener('turbo:load', function() {
  // Intercepter les clics sur les boutons "See movie details"
  document.addEventListener('click', function(e) {
    const movieDetailBtn = e.target.closest('[data-movie-id]');

    if (movieDetailBtn) {
      e.preventDefault();
      const movieId = movieDetailBtn.dataset.movieId;

      // Faire une requête AJAX pour charger les détails du film
      fetch(`/movies/${movieId}`, {
        headers: {
          'Accept': 'text/javascript',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => response.text())
      .then(script => {
        // Exécuter le JavaScript retourné (show.js.erb)
        eval(script);
      })
      .catch(error => {
        console.error('Error loading movie details:', error);
      });
    }
  });
});
