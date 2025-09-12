package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.BandaDto;
import br.com.ifs.musicshow.models.BandaModel;
import br.com.ifs.musicshow.models.UsuarioBandaModel;
import br.com.ifs.musicshow.models.UsuarioModel;
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
public class BandaService {

    private final BandaRepository bandaRepository;
    private final UsuarioBandaRepository usuarioBandaRepository;
    private final UsuarioRepository usuarioRepository;

    private final UsuarioBandaService usuarioBandaService;

    public List<BandaDto> getAll() {
        List<BandaModel> bandas = bandaRepository.findAll();
        return bandas.stream()
                .map(BandaDto::fromModel)
                .collect(Collectors.toList());
    }

    public List<BandaDto> listarBandasPorPapel(Integer idUsuario, UsuarioBandaRole papel) {
        UsuarioModel usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        return usuarioBandaRepository.findByUsuarioAndPapelUser(usuario, papel)
                .stream()
                .map(UsuarioBandaModel::getBanda)
                .map(BandaDto::fromModel)
                .toList();
    }

    public List<BandaDto> listarBandasPorMusico(Integer idUsuario) {
        return listarBandasPorPapel(idUsuario, UsuarioBandaRole.MUSICO);
    }

    public List<BandaDto> listarBandasPorMembro(Integer idUsuario) {
        return listarBandasPorPapel(idUsuario, UsuarioBandaRole.MEMBRO);
    }

    @Transactional
    public void cadastrarBanda(BandaDto bandaDto) {
        UsuarioModel usuario = usuarioRepository.findById(bandaDto.idUsuario())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        if (bandaRepository.existsByNome(bandaDto.nome())) {
            throw new RuntimeException("Já existe uma banda com este nome.");
        }

        BandaModel bandaModel = new BandaModel();
        bandaModel.setUsuario(usuario);
        bandaModel.setNome(bandaDto.nome());
        bandaModel.setQtdIntegrante(1);
        bandaModel.setQtdRepertorio(0);
        bandaModel.setDataCriacao(new Date());
        bandaModel.setStatus(BandaModel.STATUS_ATIVO);

        BandaModel novaBanda = bandaRepository.save(bandaModel);

        UsuarioBandaModel usuarioBandaModel = new UsuarioBandaModel(
                null,
                novaBanda,
                usuario,
                new Date(),
                UsuarioBandaRole.MUSICO
        );
        usuarioBandaRepository.save(usuarioBandaModel);
    }

    @Transactional
    public void atualizarBanda(Integer id, BandaDto bandaDto) {
        BandaModel bandaAtual = bandaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Banda não encontrada."));

        if (!bandaAtual.getNome().equals(bandaDto.nome()) &&
                bandaRepository.existsByNome(bandaDto.nome())) {
            throw new RuntimeException("Já existe uma banda com este nome.");
        }

        bandaAtual.setNome(bandaDto.nome());
        bandaAtual.setQtdIntegrante(bandaDto.qtdIntegrante());
        bandaAtual.setStatus(bandaDto.status());

        bandaRepository.save(bandaAtual);
    }

    @Transactional
    public void deletarBanda(Integer id) {
        if (!bandaRepository.existsById(id)) {
            throw new RuntimeException("Banda não encontrada.");
        }
        bandaRepository.deleteById(id);
    }

}
