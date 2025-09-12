package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.UsuarioBandaDto;
import br.com.ifs.musicshow.services.UsuarioBandaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/usuario-banda")
@RequiredArgsConstructor
public class UsuarioBandaController {

    private final UsuarioBandaService usuarioBandaService;

    @GetMapping("/listar")
    public ResponseEntity<List<UsuarioBandaDto>> listar() {
        return ResponseEntity.ok(usuarioBandaService.listarUsuarioBanda());
    }

    @GetMapping(value = "/listar/{idBanda}")
    public List<UsuarioBandaDto> listarUsuariosPorBanda(@PathVariable(name = "idBanda") Integer idBanda) {
        return usuarioBandaService.listarUsuariosPorBanda(idBanda);
    }

    @GetMapping("/papel-musico/{usuarioId}/{bandaId}")
    public ResponseEntity<Boolean> verificarPapelUser(@PathVariable Integer bandaId, @PathVariable Integer usuarioId) {
        boolean resultado = usuarioBandaService.getMusico(bandaId, usuarioId);
        return ResponseEntity.ok(resultado);
    }

    @GetMapping("/papel/{bandaId}/{usuarioId}")
    public ResponseEntity<String> getPapelUsuario(@PathVariable Integer bandaId, @PathVariable Integer usuarioId) {
        String papel = usuarioBandaService.getPapelUsuarioNaBanda(usuarioId, bandaId);

        if (papel == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Usuário não encontrado na banda");
        }
        return ResponseEntity.ok(papel);
    }

    @PostMapping(value = "/adicionar-membro")
    public ResponseEntity<String> adicionarMembroPorEmail(@RequestBody @Valid UsuarioBandaDto usuarioBandaDto) {
        try {
            usuarioBandaService.adicionarMembro(usuarioBandaDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Membro adicionado com sucesso");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/remover-membro")
    public ResponseEntity<String> removerMembro(@RequestBody UsuarioBandaDto usuarioBandaDto) {
        try {
             usuarioBandaService.removerMembro(usuarioBandaDto);
            return ResponseEntity.status(HttpStatus.OK).body("Membro removido com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PutMapping(value = "/atualizar/{id}")
    public ResponseEntity<String> atualizarUsuarioBanda(@PathVariable Integer id,
                                                 @RequestBody @Valid UsuarioBandaDto usuarioBandaDto) {
        try {
            usuarioBandaService.atualizarUsuarioBanda(id, usuarioBandaDto);
            return ResponseEntity.ok("Associação atualizada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/deletar/{id}")
    public ResponseEntity<String> deletarUsuarioBanda(@PathVariable(name = "id") Integer id) {
        try {
            usuarioBandaService.deletarUsuarioBanda(id);
            return ResponseEntity.ok("Associação deletada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}
