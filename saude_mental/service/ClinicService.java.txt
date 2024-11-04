package saudemental.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import saudemental.model.Clinic;
import saudemental.repository.ClinicRepository;

import java.util.List;

@Service
public class ClinicService {
    @Autowired
    private ClinicRepository clinicRepository;

    public List<Clinic> findAll() {
        return clinicRepository.findAll();
    }

    public Clinic save(Clinic clinic) {
        return clinicRepository.save(clinic);
    }

    public void delete(Long id) {
        clinicRepository.deleteById(id);
    }

    public Clinic findById(Long id) {
        return clinicRepository.findById(id).orElse(null);
    }
}
