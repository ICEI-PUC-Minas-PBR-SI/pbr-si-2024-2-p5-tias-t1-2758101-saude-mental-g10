package saudemental.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import saudemental.model.Clinic;

public interface ClinicRepository extends JpaRepository<Clinic, Long> {
}
