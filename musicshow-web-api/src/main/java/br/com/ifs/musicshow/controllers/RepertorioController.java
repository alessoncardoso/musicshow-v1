package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.RepertorioDto;
import br.com.ifs.musicshow.services.RepertorioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/repertorios")
@RequiredArgsConstructor
public class RepertorioController {

    private final RepertorioService repertorioService;

    @GetMapping("/listar")
    public ResponseEntity<List<RepertorioDto>> listarRepertorio() {
        return ResponseEntity.ok(repertorioService.listarRepertorios());
    }

    @GetMapping("/listar/{id}")
    public ResponseEntity<?> listarRepertoriosBanda(@PathVariable(name = "id") Integer idBanda) {
        try {
            return ResponseEntity.ok(repertorioService.listarRepertoriosBanda(idBanda));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @PostMapping(value = "/cadastrar")
    public ResponseEntity<String> cadastrarRepertorio(@RequestBody @Valid RepertorioDto repertorioDto) {
        try {
            repertorioService.cadastrarRepertorio(repertorioDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Repertorio criado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @PutMapping(value = "/atualizar/{id}")
    public ResponseEntity<String> atualizarRepertorio(@PathVariable Integer id,
                                                      @RequestBody @Valid RepertorioDto repertorioDto) {
        try {
            repertorioService.atualizarRepertorio(id, repertorioDto);
            return ResponseEntity.ok("Repertorio atualizado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/deletar")
    public ResponseEntity<String> deletarRepertorio(@RequestBody RepertorioDto repertorioDto) {
        try {
            repertorioService.deletarRepertorio(repertorioDto);
            return ResponseEntity.ok("Repertorio deletado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}
