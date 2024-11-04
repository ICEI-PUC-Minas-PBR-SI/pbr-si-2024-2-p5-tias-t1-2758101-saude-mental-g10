package saudemental.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import saudemental.model.Client;

public interface ClientRepository extends JpaRepository<Client, Long> {
}
