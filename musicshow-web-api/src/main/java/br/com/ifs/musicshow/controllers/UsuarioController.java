package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.UsuarioDto;
import br.com.ifs.musicshow.services.UsuarioService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final HttpSession session;

    @GetMapping("/sessao")
    public UsuarioDto getUsuarioSessao() {
        UsuarioDto usuarioLogado = (UsuarioDto) session.getAttribute("usuarioLogado");
        if (usuarioLogado == null) {
            throw new RuntimeException("Nenhum usuário logado.");
        }
        return usuarioLogado;
    }

    @PostMapping("/logout")
    public String logout() {
        session.invalidate(); // Invalida a sessão
        return "Logout realizado com sucesso.";
    }

    @GetMapping("/listar")
    public ResponseEntity<List<UsuarioDto>> listarUsuarios() {
        return ResponseEntity.ok(usuarioService.listarUsuarios());
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<?> listarPorEmail(@PathVariable(name = "email") String email) {
        try {
            return ResponseEntity.ok(usuarioService.buscarUsuarioPorEmail(email));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @GetMapping("/listar/{id}")
    public ResponseEntity<?> listarPorId(@PathVariable(name = "id") Integer id) {
        try {
            return ResponseEntity.ok(usuarioService.buscarUsuarioPorId(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @PostMapping("/autenticar")
    public ResponseEntity<?> autenticar(@RequestBody @Valid UsuarioDto usuarioDto) {
        try {
            return ResponseEntity.ok(usuarioService.autenticarUsuario(usuarioDto.email(), usuarioDto.senha()));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        }
    }

    @PostMapping("/cadastrar")
    public ResponseEntity<String> cadastrar(@RequestBody @Valid UsuarioDto usuarioDto) {
        try {
            usuarioService.cadastrarUsuario(usuarioDto);
            return ResponseEntity.ok("Usuário cadastrado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PutMapping("/atualizar/{id}")
    public ResponseEntity<String> atualizar(@PathVariable(name = "id") Integer id,
                                            @RequestBody @Valid UsuarioDto usuarioDto) {
        try {
            usuarioService.atualizarUsuario(id, usuarioDto);
            return ResponseEntity.ok("Usuário atualizado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @DeleteMapping("/deletar/{id}")
    public ResponseEntity<String> deletar(@PathVariable(name = "id") Integer id) {
        try {
            usuarioService.deletarUsuario(id);
            return ResponseEntity.ok("Usuário deletado com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
