package br.com.ifs.musicshow.services;

import br.com.ifs.musicshow.dtos.BandaMusicaDto;
import br.com.ifs.musicshow.models.BandaMusicaModel;
import br.com.ifs.musicshow.repositories.BandaMusicaRepository;
import br.com.ifs.musicshow.repositories.BandaRepository;
import br.com.ifs.musicshow.repositories.MusicaRepository;
import br.com.ifs.musicshow.repositories.RepertorioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BandaMusicaService {

    private final BandaRepository bandaRepository;
    private final MusicaRepository musicaRepository;
    private final RepertorioRepository repertorioRepository;
    private final BandaMusicaRepository bandaMusicaRepository;

    public List<BandaMusicaDto> listarTodasAssociacoes() {
        List<BandaMusicaModel> associacoes = bandaMusicaRepository.findAll();

        return associacoes.stream()
                .map(associacao -> BandaMusicaDto.fromModel(
                        associacao,
                        associacao.getMusica().getTitulo(),
                        associacao.getMusica().getArquivo()
                ))
                .collect(Collectors.toList());
    }

    public List<BandaMusicaDto> listarAssociacoesPorRepertorio(Integer idRepertorio) {
        List<BandaMusicaModel> associacoes = bandaMusicaRepository.findByRepertorioId(idRepertorio);

        return associacoes.stream()
                .map(associacao -> BandaMusicaDto.fromModel(
                        associacao,
                        associacao.getMusica().getTitulo(),
                        associacao.getMusica().getArquivo()
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void adicionarMusica(BandaMusicaDto bandaMusicaDto) {
        boolean musicaExiste = bandaMusicaRepository.existsByBandaIdAndMusicaIdAndRepertorioId(
                bandaMusicaDto.idBanda(), bandaMusicaDto.idMusica(), bandaMusicaDto.idRepertorio());
        if (musicaExiste) {
            throw new RuntimeException("Essa música já está associada ao repertório.");
        }

        Integer maiorOrdem = bandaMusicaRepository.findMaxOrdemByRepertorioId(bandaMusicaDto.idRepertorio());
        int novaOrdem = (maiorOrdem != null) ? maiorOrdem + 1 : 1;

        BandaMusicaModel bandaMusicaModel = new BandaMusicaModel(
                null,
                bandaRepository.getReferenceById(bandaMusicaDto.idBanda()),
                musicaRepository.getReferenceById(bandaMusicaDto.idMusica()),
                repertorioRepository.getReferenceById(bandaMusicaDto.idRepertorio()),
                new Date(),
                novaOrdem
        );

        bandaMusicaRepository.save(bandaMusicaModel);
        repertorioRepository.incrementarQtdMusicas(bandaMusicaDto.idRepertorio());
    }

    @Transactional
    public void cadastrarBandaMusica(BandaMusicaDto bandaMusicaDto) {

        Integer maiorOrdem = bandaMusicaRepository.findMaxOrdemByRepertorioId(bandaMusicaDto.idRepertorio());
        int novaOrdem = (maiorOrdem != null) ? maiorOrdem + 1 : 1;

        BandaMusicaModel bandaMusicaModel = new BandaMusicaModel(
                null,
                bandaRepository.getReferenceById(bandaMusicaDto.idBanda()),
                musicaRepository.getReferenceById(bandaMusicaDto.idMusica()),
                repertorioRepository.getReferenceById(bandaMusicaDto.idRepertorio()),
                new Date(),
                novaOrdem
        );

        bandaMusicaRepository.save(bandaMusicaModel);
        repertorioRepository.incrementarQtdMusicas(bandaMusicaDto.idRepertorio());
    }

    @Transactional
    public void reordenarMusicas(List<BandaMusicaModel> musicas) {
        for (BandaMusicaModel musica : musicas) {
            bandaMusicaRepository.updateOrdem(musica.getId(), musica.getOrdem());
        }
    }

    @Transactional
    public void removerMusica(BandaMusicaDto bandaMusicaDto) {
        boolean musicaExiste = bandaMusicaRepository.existsByBandaIdAndMusicaIdAndRepertorioId(
                bandaMusicaDto.idBanda(), bandaMusicaDto.idMusica(), bandaMusicaDto.idRepertorio());
        if (!musicaExiste) {
            throw new RuntimeException("A música não está associada ao repertório.");
        }

        bandaMusicaRepository.deleteById(bandaMusicaDto.id());
        repertorioRepository.decrementarQtdMusicas(bandaMusicaDto.idRepertorio());
    }

    @Transactional
    public void atualizarBandaMusica(Integer id, BandaMusicaDto bandaMusicaDto) {
        BandaMusicaModel bandaMusicaAtual = bandaMusicaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Associação não encontrada."));

        bandaMusicaAtual.setBanda(bandaRepository.getReferenceById(bandaMusicaDto.idBanda()));
        bandaMusicaAtual.setMusica(musicaRepository.getReferenceById(bandaMusicaDto.idMusica()));
        bandaMusicaAtual.setRepertorio(repertorioRepository.getReferenceById(bandaMusicaDto.idRepertorio()));
        bandaMusicaAtual.setOrdem(bandaMusicaDto.ordem());

        bandaMusicaRepository.save(bandaMusicaAtual);
    }

}
