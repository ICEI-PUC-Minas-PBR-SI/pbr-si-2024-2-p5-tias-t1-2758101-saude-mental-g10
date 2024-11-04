package saudemental.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import saudemental.model.Doubt;
import saudemental.repository.DoubtRepository;

import java.util.List;

@Service
public class DoubtService {
    @Autowired
    private DoubtRepository doubtRepository;

    public List<Doubt> findAll() {
        return doubtRepository.findAll();
    }

    public Doubt save(Doubt doubt) {
        return doubtRepository.save(doubt);
    }

    public void delete(Long id) {
        doubtRepository.deleteById(id);
    }

    public Doubt findById(Long id) {
        return doubtRepository.findById(id).orElse(null);
    }
}
