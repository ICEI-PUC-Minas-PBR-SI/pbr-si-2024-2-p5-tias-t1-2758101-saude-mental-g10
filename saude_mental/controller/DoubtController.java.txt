package saudemental.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import saudemental.model.Doubt;
import saudemental.service.DoubtService;

import java.util.List;

@RestController
@RequestMapping("/doubts")
public class DoubtController {

    @Autowired
    private DoubtService doubtService;

    // Criar uma nova dúvida
    @PostMapping
    public ResponseEntity<Doubt> createDoubt(@RequestBody Doubt doubt) {
        Doubt createdDoubt = doubtService.createDoubt(doubt);
        return ResponseEntity.ok(createdDoubt);
    }

    // Obter todas as dúvidas
    @GetMapping
    public ResponseEntity<List<Doubt>> getAllDoubts() {
        List<Doubt> doubts = doubtService.getAllDoubts();
        return ResponseEntity.ok(doubts);
    }

    // Obter uma dúvida específica por ID
    @GetMapping("/{id}")
    public ResponseEntity<Doubt> getDoubtById(@PathVariable Long id) {
        Doubt doubt = doubtService.getDoubtById(id);
        if (doubt != null) {
            return ResponseEntity.ok(doubt);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Atualizar uma dúvida existente
    @PutMapping("/{id}")
    public ResponseEntity<Doubt> updateDoubt(@PathVariable Long id, @RequestBody Doubt doubt) {
        Doubt updatedDoubt = doubtService.updateDoubt(id, doubt);
        if (updatedDoubt != null) {
            return ResponseEntity.ok(updatedDoubt);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Excluir uma dúvida
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDoubt(@PathVariable Long id) {
        boolean deleted = doubtService.deleteDoubt(id);
        if (deleted) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
