package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.MusicaDto;
import br.com.ifs.musicshow.services.MusicaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/musicas")
@RequiredArgsConstructor
public class MusicaController {

    private final MusicaService musicaService;

    @GetMapping("/listar")
    public ResponseEntity<List<MusicaDto>> listarMusicas() {
        return ResponseEntity.ok(musicaService.listarMusicas());
    }

    @GetMapping(value = "/listar/{id}")
    public ResponseEntity<?> listarMusicasResponsavel(@PathVariable(name = "id") Integer id) {
        try {
            return ResponseEntity.ok(musicaService.listarMusicasResponsavel(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @GetMapping("/usuario/{idUsuario}/titulo/{titulo}")
    public ResponseEntity<?> listarPorTituloEUsuario( @PathVariable Integer idUsuario, @PathVariable String titulo) {
        try {
            return ResponseEntity.ok(musicaService.buscarMusicasPorTituloEUsuario(idUsuario, titulo));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @PostMapping("/cadastrar")
    public ResponseEntity<String> cadastrarMusica(@RequestBody @Valid MusicaDto musicaDto) {
        try {
            musicaService.cadastrarMusica(musicaDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Música criada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @PutMapping(value = "/atualizar/{id}")
    public ResponseEntity<String> atualizarMusica(@PathVariable Integer id,
                                                  @RequestBody @Valid MusicaDto musicaDto) {
        try {
            musicaService.atualizarMusica(id, musicaDto);
            return ResponseEntity.ok("Música atualizada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/deletar/{id}")
    public ResponseEntity<String> deletarMusica(@PathVariable(name = "id") Integer id) {
        try {
            musicaService.deletarMusica(id);
            return ResponseEntity.ok("Música deletada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}
