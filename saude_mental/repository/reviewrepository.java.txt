package saudemental.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import saudemental.model.Review;

public interface ReviewRepository extends JpaRepository<Review, Long> {
}
