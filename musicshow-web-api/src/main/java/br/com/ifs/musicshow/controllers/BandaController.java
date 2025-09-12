package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.BandaDto;
import br.com.ifs.musicshow.services.BandaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/bandas")
@RequiredArgsConstructor
public class BandaController {

    private final BandaService bandaService;

    @GetMapping("/listar")
    public ResponseEntity<List<BandaDto>> buscar() {
        return ResponseEntity.ok(bandaService.getAll());
    }

    @GetMapping("/membro/{idUsuario}")
    public ResponseEntity<?> listarBandasMembro(@PathVariable Integer idUsuario) {
        try {
            return ResponseEntity.ok(bandaService.listarBandasPorMembro(idUsuario));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @GetMapping("/musico/{idUsuario}")
    public ResponseEntity<?> listarBandasMusico(@PathVariable Integer idUsuario) {
        try {
            return ResponseEntity.ok(bandaService.listarBandasPorMusico(idUsuario));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @PostMapping(value = "/cadastrar")
    public ResponseEntity<String> cadastrarBanda(@RequestBody @Valid BandaDto bandaDto) {
        try {
            bandaService.cadastrarBanda(bandaDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Banda criada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @PutMapping(value = "/atualizar/{id}")
    public ResponseEntity<String> atualizarBanda(@PathVariable Integer id,
                                                 @RequestBody @Valid BandaDto bandaDto) {
        try {
            bandaService.atualizarBanda(id, bandaDto);
            return ResponseEntity.ok("Banda atualizada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/deletar/{id}")
    public ResponseEntity<String> deletarBanda(@PathVariable(name = "id") Integer id) {
        try {
            bandaService.deletarBanda(id);
            return ResponseEntity.ok("Banda deletada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}
