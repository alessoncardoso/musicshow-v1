package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.UsuarioDto;
import br.com.ifs.musicshow.models.UsuarioModel;
import br.com.ifs.musicshow.repositories.BandaRepository;
import br.com.ifs.musicshow.repositories.UsuarioBandaRepository;
import br.com.ifs.musicshow.repositories.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioBandaRepository usuarioBandaRepository;
    private final BandaRepository bandaRepository;
    private final PasswordEncoder passwordEncoder;
    private final HttpSession session;


    public List<UsuarioDto> listarUsuarios() {
        List<UsuarioModel> usuarios = usuarioRepository.findAll();
        if (usuarios.isEmpty()) {
            throw new RuntimeException("Nenhum usuário encontrado.");
        }
        return usuarios.stream()
                .map(UsuarioDto::fromModel)
                .collect(Collectors.toList());
    }

    public UsuarioDto buscarUsuarioPorId(Integer id) {
        UsuarioModel usuarioModel = usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        return UsuarioDto.fromModel(usuarioModel);
    }

    public Optional<UsuarioDto> buscarUsuarioPorEmail(String email) {
        Optional<UsuarioModel> usuario = usuarioRepository.findByEmail(email);
        if (usuario.isEmpty()) {
            throw new RuntimeException("Usuário não encontrado.");
        }
        return Optional.of(UsuarioDto.fromModel(usuario.get()));
    }

    @Transactional
    public UsuarioDto autenticarUsuario(String email, String senha) {
        Optional<UsuarioModel> usuarioModelOptional = usuarioRepository.findByEmail(email);

        if (usuarioModelOptional.isEmpty()) {
            throw new RuntimeException("Email inválido.");
        }

        UsuarioModel usuarioExistente = usuarioModelOptional.get();

        if (!passwordEncoder.matches(senha, usuarioExistente.getSenha())) {
            throw new RuntimeException("Senha inválida.");
        }

        UsuarioDto usuarioDtoSessao = UsuarioDto.fromModel(usuarioExistente);
        session.setAttribute("usuarioLogado", usuarioDtoSessao);

        return usuarioDtoSessao;
    }

    @Transactional
    public void cadastrarUsuario(UsuarioDto usuarioDto) {
        if (usuarioRepository.existsByEmail(usuarioDto.email().toLowerCase())) {
            throw new RuntimeException("Já existe um usuário cadastrado com este e-mail.");
        }

        UsuarioModel usuarioModel = new UsuarioModel();
        usuarioModel.setNome(usuarioDto.nome());
        usuarioModel.setEmail(usuarioDto.email());
        usuarioModel.setSenha(passwordEncoder.encode(usuarioDto.senha()));
        usuarioModel.setDataCriacao(Calendar.getInstance().getTime());
        usuarioModel.setStatus(UsuarioModel.STATUS_ATIVO);

        usuarioRepository.save(usuarioModel);
    }

    @Transactional
    public void atualizarUsuario(Integer id, UsuarioDto usuarioDto) {
        if (id <= 0) {
            throw new RuntimeException("O ID fornecido é inválido. Verifique o valor e tente novamente.");
        }

        UsuarioModel usuarioAtual = usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        boolean usuarioComEmailExistente = usuarioRepository.existsByEmail(usuarioDto.email().toLowerCase());

        if (!usuarioAtual.getEmail().equals(usuarioDto.email()) && usuarioComEmailExistente) {
            throw new RuntimeException("O email fornecido já existe. Escolha um email diferente.");
        }

        usuarioAtual.setNome(usuarioDto.nome());
        usuarioAtual.setEmail(usuarioDto.email());

        if (usuarioDto.senha() != null && !usuarioDto.senha().isEmpty()) {
            usuarioAtual.setSenha(passwordEncoder.encode(usuarioDto.senha()));
        }

        usuarioAtual.setStatus(usuarioDto.status());

        usuarioRepository.save(usuarioAtual);

        UsuarioDto usuarioDtoSessao = UsuarioDto.fromModel(usuarioAtual);
        session.setAttribute("usuarioLogado", usuarioDtoSessao);
    }

    @Transactional
    public void deletarUsuario(Integer id) {
        if (!usuarioRepository.existsById(id)) {
            throw new RuntimeException("Usuário não encontrado.");
        }
        usuarioRepository.deleteById(id);
    }

}