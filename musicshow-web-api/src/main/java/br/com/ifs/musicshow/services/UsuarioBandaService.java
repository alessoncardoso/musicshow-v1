package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.UsuarioBandaDto;
import br.com.ifs.musicshow.models.UsuarioBandaModel;
import br.com.ifs.musicshow.repositories.BandaRepository;
import br.com.ifs.musicshow.repositories.UsuarioBandaRepository;
import br.com.ifs.musicshow.repositories.UsuarioRepository;
import br.com.ifs.musicshow.roles.UsuarioBandaRole;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UsuarioBandaService {

    private final BandaRepository bandaRepository;
    private final UsuarioRepository usuarioRepository;
    private final UsuarioBandaRepository usuarioBandaRepository;

    public List<UsuarioBandaDto> listarUsuarioBanda() {
        return usuarioBandaRepository.findAll()
                .stream()
                .map(usuarioBanda -> UsuarioBandaDto.fromModel(
                        usuarioBanda, usuarioBanda.getUsuario().getNome()
                ))
                .collect(Collectors.toList());
    }

    public List<UsuarioBandaDto> listarUsuariosPorBanda(Integer idBanda) {
        return usuarioBandaRepository.findByBandaId(idBanda)
                .stream()
                .map(usuarioBanda -> UsuarioBandaDto.fromModel(
                        usuarioBanda, usuarioBanda.getUsuario().getNome()
                ))
                .collect(Collectors.toList());
    }

    public boolean getMusico(Integer bandaId, Integer usuarioId) {
        boolean isMusico = usuarioBandaRepository.existsByBandaIdAndUsuarioIdAndPapelUser(
                bandaId, usuarioId, UsuarioBandaRole.MUSICO);

        return isMusico;
    }

    public String getPapelUsuarioNaBanda(Integer bandaId, Integer usuarioId) {
        return usuarioBandaRepository.findByBandaId(bandaId)
                .stream()
                .filter(ub -> ub.getUsuario().getId().equals(usuarioId))
                .map(ub -> ub.getPapelUser().name())
                .findFirst()
                .orElse(null);
    }

    @Transactional
    public void adicionarMembro(UsuarioBandaDto usuarioBandaDto) {
        boolean integranteExiste = usuarioBandaRepository.existsByBandaIdAndUsuarioId(
                usuarioBandaDto.idBanda(), usuarioBandaDto.idUsuario());
        if (integranteExiste) {
            throw new RuntimeException("O usuário já é integrante desta banda.");
        }

        UsuarioBandaModel usuarioBandaModel = new UsuarioBandaModel(
                null,
                bandaRepository.getReferenceById(usuarioBandaDto.idBanda()),
                usuarioRepository.getReferenceById(usuarioBandaDto.idUsuario()),
                new Date(),
                UsuarioBandaRole.MEMBRO
        );

        usuarioBandaRepository.save(usuarioBandaModel);
        bandaRepository.incrementarQtdIntegrantes(usuarioBandaDto.idBanda());
    }

    @Transactional
    public void removerMembro(UsuarioBandaDto usuarioBandaDto) {
        boolean integranteExiste = usuarioBandaRepository.existsByBandaIdAndUsuarioIdAndPapelUser(
                usuarioBandaDto.idBanda(), usuarioBandaDto.idUsuario(), UsuarioBandaRole.MEMBRO);
        if (!integranteExiste) {
            throw new RuntimeException("O usuário não é integrante desta banda.");
        }

        usuarioBandaRepository.deleteById(usuarioBandaDto.id());
        bandaRepository.decrementarQtdIntegrantes(usuarioBandaDto.idBanda());
    }

    @Transactional
    public void atualizarUsuarioBanda(Integer id, UsuarioBandaDto usuarioBandaDto) {
        UsuarioBandaModel usuarioBandaAtual = usuarioBandaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Associação não encontrada."));

        usuarioBandaAtual.setBanda(bandaRepository.getReferenceById(usuarioBandaDto.idBanda()));
        usuarioBandaAtual.setUsuario(usuarioRepository.getReferenceById(usuarioBandaDto.idUsuario()));
        usuarioBandaAtual.setPapelUser(UsuarioBandaRole.valueOf(usuarioBandaDto.papelUser()));

        usuarioBandaRepository.save(usuarioBandaAtual);
    }

    @Transactional
    public void deletarUsuarioBanda(Integer id) {
        if (!usuarioBandaRepository.existsById(id)) {
            throw new RuntimeException("Associação não encontrada.");
        }
        usuarioBandaRepository.deleteById(id);
    }

}
