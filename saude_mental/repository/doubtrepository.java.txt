package saudemental.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import saudemental.model.Doubt;

public interface DoubtRepository extends JpaRepository<Doubt, Long> {
}
