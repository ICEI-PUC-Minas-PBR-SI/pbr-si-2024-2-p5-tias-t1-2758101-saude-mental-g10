package saudemental.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import saudemental.model.Clinic;
import saudemental.service.ClinicService;

import java.util.List;

@RestController
@RequestMapping("/clinics")
public class ClinicController {
    @Autowired
    private ClinicService clinicService;

    @GetMapping
    public List<Clinic> getAllClinics() {
        return clinicService.findAll();
    }

    @PostMapping
    public Clinic createClinic(@RequestBody Clinic clinic) {
        return clinicService.save(clinic);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Clinic> getClinicById(@PathVariable Long id) {
        Clinic clinic = clinicService.findById(id);
        return clinic != null ? ResponseEntity.ok(clinic) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteClinic(@PathVariable Long id) {
        clinicService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
